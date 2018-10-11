package locate

import (
	"encoding/json"
	"lib/rabbitmq"
	"lib/rs"
	"lib/types"
	"os"
	"time"
	"lib/dlog"
)

func Locate(name string) (locateInfo map[int]string) {
	q := rabbitmq.New(os.Getenv("RABBITMQ_SERVER"))
	q.Publish("dataServers", name)
	c := q.Consume()
	go func() {
		time.Sleep(time.Second)
		q.Close()
	}()
	//分片map[index]=addr
	dlog.Debug("get locateInfo")
	locateInfo = make(map[int]string)
	for i := 0; i < rs.ALL_SHARDS; i++ {
		//这里如果没有6个数据读取会卡死吗
		msg := <-c
		if len(msg.Body) == 0 {
			return
		}
		var info types.LocateMessage
		json.Unmarshal(msg.Body, &info)
		//index到address
		//logger.Debug("read id:%d addr:%s",info.Id,info.Addr)
		dlog.Debug("read id:%d addr:%s",info.Id,info.Addr)
		locateInfo[info.Id] = info.Addr
	}
	return
}

func Exist(name string) bool {
	return len(Locate(name)) >= rs.DATA_SHARDS
}
