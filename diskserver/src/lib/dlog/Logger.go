package dlog

import (
	"sync"
	"io"
	"fmt"
	"time"
	"runtime"
)

type writeBuffer struct {
	buf []byte
}

func (wr *writeBuffer) Reset() {
	wr.buf = wr.buf[:0]
}

func (wr *writeBuffer) Bytes() []byte {
	n := len(wr.buf)
	if last := wr.buf[n-1]; last != '\n' {
		if n == cap(wr.buf) {
			wr.buf[n-1] = '\n'
		} else {
			wr.buf = append(wr.buf, '\n')
		}
	}

	return wr.buf
}

func (wr *writeBuffer) Write(data []byte) (int, error) {
	remaining := cap(wr.buf) - len(wr.buf)
	if len(data) > remaining {
		wr.buf = append(wr.buf, data[:remaining]...)
		return remaining, io.ErrShortWrite
	} else {
		wr.buf = append(wr.buf, data...)
		return len(data), nil
	}
}

type Logger struct {
	mutex     sync.Mutex
	formatter Formatter
	writer    io.Writer
	severity  int
	buffer writeBuffer
}

func NewLogger(wr io.Writer, lv int, format Formatter) *Logger {
	return &Logger{
		writer:    wr,
		severity:  lv,
		formatter: format,
		buffer:    writeBuffer{make([]byte, 4096)},
	}
}

func (logger *Logger) setLevel(lv int){
	logger.severity = lv
}
/*func (logger *Logger) Log(lv int, args ...interface{}) {
	var rec Record
	rec.Severity = lv
	rec.Message = fmt.Sprint(args...)

	rec.When = time.Now()
	_, rec.File, rec.Line, _ = runtime.Caller(3)
	logger.writeRecord(&rec)
}*/

func (logger *Logger) Log(lv int, args ...interface{}) *Record{
	var rec Record
	rec.Severity = lv
	rec.Message = fmt.Sprint(args...)

	rec.When = time.Now()
	_, rec.File, rec.Line, _ = runtime.Caller(3)
	return  &rec
}

func (logger *Logger) writeRecord(rec *Record) []byte {
	logger.mutex.Lock()
	defer logger.mutex.Unlock()

	logger.buffer.Reset()
	logger.formatter.Format(&logger.buffer, rec)
	b := logger.buffer.Bytes()
	logger.writer.Write(b)
	return b
}