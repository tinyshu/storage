package dlog

import (
	"os"
	"fmt"
	"time"
	"path/filepath"
	)

//定义默认log对象
var defaultBasename = filepath.Base(os.Args[0])
//var pathargs = os.Getenv("STORAGE_ROOT")
//var defaultProcname = fmt.Sprintf("%s[%d]", pathargs[len(pathargs)-1:])

var Rotate = NewDayRotate()
var defaultlogger = NewFileLog("./",defaultBasename,0,Rotate)

type FileLogger struct{
	level int
	logPath string
	logName string
	debugfile *os.File
	dLogger   *Logger
	Rotate    IRotate
	record  chan *Record
}


func NewFileLog(p string,n string,l int,Rotate IRotate) ILog{
	logger := &FileLogger{
		logPath: p,
		logName: n,
		level:l,
		Rotate:Rotate,
		record:make(chan *Record,5000),
	}

	logger.init()
	return logger
}

func (f *FileLogger) init() {

	if f.open() != nil{
		return
	}

	defaultBasename := filepath.Base(os.Args[0])
	defaultProcname := fmt.Sprintf("%s[%d]", defaultBasename, os.Getpid())
	if f.dLogger == nil{
		f.dLogger = NewLogger(f.debugfile ,LogLevelDebug,newFileFormatter(defaultProcname))
	}

	if f.Rotate == nil{
		f.Rotate = &NoRotate{}
	}

	go f.WriteLogAtBack()
}

func (f *FileLogger) open() error {

	if f.debugfile == nil{
		timeNow := time.Now()
		fileName := fmt.Sprintf("%s/%s_%04d%02d%02d.log",f.logPath,f.logName,timeNow.Year(),timeNow.Month(),timeNow.Day())
		file,err := os.OpenFile(fileName,os.O_WRONLY |os.O_CREATE | os.O_APPEND,0644)
		if err != nil{
			panic(fmt.Sprintf("open file %s,%v",fileName,err))
		}

		f.debugfile = file
	}


	//判断是否需要混动log文件
	if  suffix,ok:= f.Rotate.Rotate(time.Now()); ok {
		f.debugfile.Close()
		linkname := filepath.Join(f.logPath, f.logName)
		fullfilename := linkname + "_" + suffix + ".log"
		if file, err := os.OpenFile(fullfilename, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644); err != nil {
			return err
		} else {
			f.debugfile = file
			os.Remove(linkname + ".log")
			os.Symlink(f.logName + suffix + ".log", linkname+"log")
		}
	}

	return nil
}

func (f *FileLogger)SetLevel(level int)  {
	if level < LogLevelDebug || level >LogLevelFatal{
		level = LogLevelDebug
	}
	f.level = level
	f.dLogger.setLevel(level)
}

func (f *FileLogger)logmsg(msg ... interface{}){
	if err:= f.open(); err != nil{
		return
	}

	r := f.dLogger.Log(f.level,msg)
	select {
	case f.record <- r:
	default:
		}

}

func (f *FileLogger) WriteLogAtBack(){

	for r := range f.record{
		f.dLogger.writeRecord(r)
	}
}

func (f *FileLogger)Debug(msg ... interface{}){
	if f.level > LogLevelDebug{
		return
	}

	f.logmsg(msg...)
}
func (f *FileLogger)Trace(msg ... interface{}){
	if f.level > LogLevelTrace{
		return
	}
	f.logmsg(msg...)
}

func (f *FileLogger)Info(msg ... interface{}){
	if f.level > LogLevelInfo{
		return
	}
	f.logmsg(msg...)
}

func (f *FileLogger)Warm(msg ... interface{}){
	if f.level > LogLevelWarm{
		return
	}
	f.logmsg(msg...)
}

func (f *FileLogger)Error(msg ... interface{}){
	if f.level > LogLevelError{
		return
	}
	f.logmsg(msg...)
}

func (f *FileLogger)Fatal(msg ... interface{}){
	if f.level > LogLevelFatal{
		return
	}

	f.logmsg(msg...)
}

////////////////////////////////////////////
func Debug(msg ... interface{}){
	//if defaultlogger.level > LogLevelDebug{
	//	return
	//}

	defaultlogger.Debug(msg...)
}