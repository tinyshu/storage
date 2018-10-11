package dlog

type ILog interface {
	SetLevel(level int)
	Debug(msg ... interface{})
	Trace(msg ... interface{})
	Info(msg ... interface{})
	Warm(msg ... interface{})
	Error(msg ... interface{})
	Fatal(msg ... interface{})
}
