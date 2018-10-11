### EasyDisk

EasyDisk是一个个人存储网络，其目标是成为一个通用，易扩展，高效稳定的个人网盘。



#### 1.主要功能描述

**服务器主要功能**

1.支持平行扩展，是有接口都支持rest。

2.数据效验和去重。

3.数据使用栅格码编码提供数据冗余。

4.数据及时修复。

5.数据断点续传。



**客户端主要功能**

1.数据下载和上传

2.数据分类

3.数据分享(待实现)



#### 2.技术选型

##### 服务器端

开发语言：go

消息队列:   rabbitmq

搜索引擎：elasticsearch

协议        :   http



##### 客户端

开发语言 ：界面qt quick  逻辑 C++



#### 3.服务端架构

https://github.com/tinyshu/storage.git/raw/master/resources/images/server.jpg



#### 客户端UI

https://github.com/tinyshu/storage.git/raw/master/resources/images/client.png

### 4.编译和部署

​     待增加

### 5.后续计划功能

​    1.支持https协议

​    2.增加用户中心功能

