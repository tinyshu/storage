package temp

import (
	"../locate"
	"io"
	"lib/es"
	"lib/rs"
	"lib/utils"
	"log"
	"net/http"
	"net/url"
	"strings"
)

func put(w http.ResponseWriter, r *http.Request) {
	token := strings.Split(r.URL.EscapedPath(), "/")[2]
	stream, e := rs.NewRSResumablePutStreamFromToken(token)
	if e != nil {
		log.Println(e)
		w.WriteHeader(http.StatusForbidden)
		return
	}
	//获取当前已经上传文件大小
	//逻辑是向数据服务层请求HEAD方法，数据服务层会读取一个uuid.dat文件大小*6
	//
	current := stream.CurrentSize()
	if current == -1 {
		w.WriteHeader(http.StatusNotFound)
		return
	}
	//读取client当前上传进度，range字段
	offset := utils.GetOffsetFromHeader(r.Header)
	if current != offset {
		w.WriteHeader(http.StatusRequestedRangeNotSatisfiable)
		return
	}
	//BLOCK_SIZE(8000*4) 一次写入数据大小
	//4个块使用栅格码4+2形式
	//6个数据块分别写入到6个数据服务层uuid.dat文件
	bytes := make([]byte, rs.BLOCK_SIZE)
	for {
		//n返回本次实际读取到的字节数
		n, e := io.ReadFull(r.Body, bytes)
		if e != nil && e != io.EOF && e != io.ErrUnexpectedEOF {
			log.Println(e)
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		current += int64(n)
		if current > stream.Size {
			stream.Commit(false)
			log.Println("resumable put exceed size")
			w.WriteHeader(http.StatusForbidden)
			return
		}
		//如果没有收到block_size大小，并且也不是最后的数据，先返回
		//进入到这个if应该也是一种错误，先不处理
		if n != rs.BLOCK_SIZE && current != stream.Size {
			return
		}
		//写入本次client上传的全部数据
		stream.Write(bytes[:n])
		if current == stream.Size {
			stream.Flush()
			//RSResumableGetStream
			getStream, e := rs.NewRSResumableGetStream(stream.Servers, stream.Uuids, stream.Size)
			hash := url.PathEscape(utils.CalculateHash(getStream))
			if hash != stream.Hash {
				stream.Commit(false)
				log.Println("resumable put done but hash mismatch")
				w.WriteHeader(http.StatusForbidden)
				return
			}
			if locate.Exist(url.PathEscape(hash)) {
				stream.Commit(false)
			} else {
				stream.Commit(true)
			}
			e = es.AddVersion(stream.Name, stream.Hash, stream.Size)
			if e != nil {
				log.Println(e)
				w.WriteHeader(http.StatusInternalServerError)
			}
			return
		}
	}
}
