package rs

import (
	"github.com/klauspost/reedsolomon"
	"io"
)

type decoder struct {
	readers   []io.Reader //存储了整个文件数据分ALL_SHARDS
	writers   []io.Writer
	enc       reedsolomon.Encoder
	size      int64   //整体数据大小
	cache     []byte  //存储读取的数据
	cacheSize int     //当前缓存数据大小
	total     int64   //当前已经读取字节数
}

func NewDecoder(readers []io.Reader, writers []io.Writer, size int64) *decoder {
	enc, _ := reedsolomon.New(DATA_SHARDS, PARITY_SHARDS)
	return &decoder{readers, writers, enc, size, nil, 0, 0}
}

func (d *decoder) Read(p []byte) (n int, err error) {
	if d.cacheSize == 0 {
		e := d.getData()
		if e != nil {
			return 0, e
		}
	}
	//计算p空间大小
	length := len(p)
	//判断缓存和p,用较小的存储
	if d.cacheSize < length {
		length = d.cacheSize
	}
	d.cacheSize -= length
	//copy length数据到p
	copy(p, d.cache[:length])
	//去掉前面length数据
	d.cache = d.cache[length:]
	return length, nil
}

func (d *decoder) getData() error {
	//判断已解码的数据是否等于数据总大小
	if d.total == d.size {
		return io.EOF
	}
	//6行二维数组
	shards := make([][]byte, ALL_SHARDS)
	repairIds := make([]int, 0)
	//读取6个数据块(每块8000字节)恢复成一个原始数据块(32000字节)
	for i,_ := range shards {
		if d.readers[i] == nil {
			//说明这个分片已经丢失
			repairIds = append(repairIds, i)
		} else {
			shards[i] = make([]byte, BLOCK_PER_SHARD)
			/*  125页
			1. 如果 data.txt 是空，则返回 EOF 错误。

            2. 如果 data.txt 少于 10 个字节， 则返回 ErrUnexpectedEOF 错误。并返回读取的字节。

			3. 其他情况，正常返回 10 个字节，错误是 nil 。
			*/
			n, e := io.ReadFull(d.readers[i], shards[i])
			if e != nil && e != io.EOF && e != io.ErrUnexpectedEOF {
				//读取错误
				shards[i] = nil
			} else if n != BLOCK_PER_SHARD {
				//读取到的数据小于BLOCK_PER_SHARD
				shards[i] = shards[i][:n]
			}
		}
	}
	//栅格码恢复数据为4个数据片
	e := d.enc.Reconstruct(shards)
	if e != nil {
		return e
	}
	for i := range repairIds {
		id := repairIds[i]
		d.writers[id].Write(shards[id])
	}
	//把恢复的4个数据片一次写入cache
	for i := 0; i < DATA_SHARDS; i++ {
		shardSize := int64(len(shards[i]))
		if d.total+shardSize > d.size {
			shardSize -= d.total + shardSize - d.size
		}
		d.cache = append(d.cache, shards[i][:shardSize]...)
		d.cacheSize += int(shardSize)
		d.total += shardSize
	}
	return nil
}
