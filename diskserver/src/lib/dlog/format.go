package dlog

import (
	"fmt"
	"io"
	"strings"
)

type Formatter interface {
	Format(wr io.Writer, rec *Record)
}

type fileFormatter struct {
	procname string
	buf      []byte
}

func newFileFormatter(name string) Formatter {
	b := make([]byte, 0, 4096)
	return &fileFormatter{
		procname: name,
		buf:      b,
	}
}

func (wr *fileFormatter) Write(data []byte) (int, error) {
	remaining := cap(wr.buf) - len(wr.buf)
	if len(data) > remaining {
		wr.buf = append(wr.buf, data[:remaining]...)
		return remaining, io.ErrShortWrite
	} else {
		wr.buf = append(wr.buf, data...)
		return len(data), nil
	}
}

func (f *fileFormatter) Format(wr io.Writer, rec *Record) {

	strLevel := converLevel(rec.Severity)
	if rec.Line > 0 {
		file := rec.File
		if pos := strings.Index(file, "/src/"); pos >= 0 {
			file = file[pos+5:]
		}

		fmt.Fprintf(wr, "%s %02d:%02d:%02d.%06d %s %s:%d: %s",
			strLevel,                                                             //level name
			rec.When.Hour(), rec.When.Minute(), rec.When.Second(), rec.When.Nanosecond()/1000, //datetime(with microseconds)
			f.procname,     //process name and id
			file, rec.Line, //file and line no
			rec.Message, //message
		)
	} else {
		fmt.Fprintf(wr, "%s %02d:%02d:%02d.%06d %s %s",
			strLevel,                                                             //level name
			rec.When.Hour(), rec.When.Minute(), rec.When.Second(), rec.When.Nanosecond()/1000, //datetime(with microseconds)
			f.procname,  //process name and id
			rec.Message, //message
		)
	}

}
