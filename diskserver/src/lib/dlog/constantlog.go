package dlog

import "time"

const (
	LogLevelDebug = iota
	LogLevelTrace
	LogLevelInfo
	LogLevelWarm
	LogLevelError
	LogLevelFatal
)


type Record struct {
	When     time.Time
	Severity int
	File     string
	Line     int
	Message  string
}

func converLevel(lv int)string{
	switch lv {
	case LogLevelDebug:
		return "Debug"
	case LogLevelTrace:
		return "Trace"
	case LogLevelInfo:
		return "Info"
	case LogLevelWarm:
		return "Warm"
	case LogLevelError:
		return "Error"
	case LogLevelFatal:
		return "Fatal"
	default:
		return "Debug"
	}

	return  ""
}