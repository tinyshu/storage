package rs

import (
	"fmt"
	"io"
	"lib/objectstream"
)

type RSPutStream struct {
	*encoder
}

func NewRSPutStream(dataServers []string, hash string, size int64) (*RSPutStream, error) {
	if len(dataServers) != ALL_SHARDS {
		return nil, fmt.Errorf("dataServers number mismatch")
	}

	//把整体数据等分4g个片
	perShard := (size + DATA_SHARDS - 1) / DATA_SHARDS
	writers := make([]io.Writer, ALL_SHARDS)
	var e error
	for i,_ := range writers {
		/*
		  返回TempPutStream{serverip,uuid}
		  每个TempPutStream在数据服务层会被创建2个文件 uuid和uuid.data
		  uuid存储数据元信息，uuid serverip size
		  uuid.data存储实际数据
		  hash.1 .....hash.6
		  每次循环调用POST请求，创建uuid和uuid.data文件
		  由于使用的栅格码算法做数据备份，整个文件会分成4+2的形式
		  4个原始数据块，2个备份块，在数据服务层hash.i形式
		  先写到这个临时文件
		*/
		writers[i], e = objectstream.NewTempPutStream(dataServers[i],
			fmt.Sprintf("%s.%d", hash, i), perShard)
		if e != nil {
			return nil, e
		}
	}
	enc := NewEncoder(writers)

	return &RSPutStream{enc}, nil
}

func (s *RSPutStream) Commit(success bool) {
	s.Flush()
	for i := range s.writers {
		s.writers[i].(*objectstream.TempPutStream).Commit(success)
	}
}
