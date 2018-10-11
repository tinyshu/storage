package dlog

import (
	"time"
	"fmt"
)

//控制log文件滚动方式 不滚动 按天，月滚动
type IRotate interface {
	Rotate(time time.Time)(string,bool)
}

type NoRotate struct{

}

func (r *NoRotate)Rotate(time time.Time)(string,bool){
	return "",false
}

type DayRotate struct {
	day int
}

func (r *DayRotate)Rotate(time time.Time)(string,bool){
	if r.day != time.Day(){
		suffix := fmt.Sprintf("%04d%02d%02d",time.Year(),time.Month(),time.Day())
		r.day = time.Day()
		return suffix,true
	}

	return "",false
}

func NewDayRotate()(*DayRotate){
	return &DayRotate{
		time.Now().Day(),
	}
}