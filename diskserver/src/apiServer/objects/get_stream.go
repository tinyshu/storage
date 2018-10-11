package objects

import (
	"../heartbeat"
	"../locate"
	"fmt"
	"lib/rs"
)

func GetStream(hash string, size int64) (*rs.RSGetStream, error) {
	//通过hash获取数据层map[index]=address
	locateInfo := locate.Locate(hash)
	if len(locateInfo) < rs.DATA_SHARDS {
		return nil, fmt.Errorf("object %s locate fail, result %v", hash, locateInfo)
	}
	dataServers := make([]string, 0)
	if len(locateInfo) != rs.ALL_SHARDS {
		dataServers = heartbeat.ChooseRandomDataServers(rs.ALL_SHARDS-len(locateInfo), locateInfo)
	}
	/*
	取数据层map[index]=address
	dataServers分片数据所在那几个server上
	hash 数据hash
	size 数据大小
	*/
	return rs.NewRSGetStream(locateInfo, dataServers, hash, size)
}
