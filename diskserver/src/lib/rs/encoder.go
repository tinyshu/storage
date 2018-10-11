package rs

import (
	"github.com/klauspost/reedsolomon"
	"io"
)

type encoder struct {
	writers []io.Writer //objectstream.NewTempPutStream
	enc     reedsolomon.Encoder
	cache   []byte //不初始化 len(cache)==0
}

func NewEncoder(writers []io.Writer) *encoder {
	enc, _ := reedsolomon.New(DATA_SHARDS, PARITY_SHARDS)
	return &encoder{writers, enc, nil}
}

//在put先把token转成stream对象后，会调用这里的Write函数
//p不大于32000字节，除最后一次读写可能小于32000字节
//其他应该p=32000直接 {p:abc,m:{}}
func (e *encoder) Write(p []byte) (n int, err error) {
	length := len(p)
	current := 0
	//for主要逻辑按照32000字节每次先写入cache空间
	//如果cache里有32000字节数据，做一次数据服务层数据写入
	//cache数据小于32000，先不处理
	//把传入的p数据全部处理完退出循环
	for length != 0 {
		next := BLOCK_SIZE - len(e.cache)
		if next > length {
			next = length
		}
		e.cache = append(e.cache, p[current:current+next]...)
		if len(e.cache) == BLOCK_SIZE {
			e.Flush()
		}
		current += next
		length -= next
	}
	return len(p), nil
}

func (e *encoder) Flush() {
	if len(e.cache) == 0 {
		return
	}
	//4个数据块,先编码成4+2个数据块
	shards, _ := e.enc.Split(e.cache)
	e.enc.Encode(shards)
	//调用writers(指向TempPutStream对象)请求数据服务层写入6个数据块
	for i := range shards {
		e.writers[i].Write(shards[i])
	}
	e.cache = []byte{}
}
