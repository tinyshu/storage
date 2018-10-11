#include "filemodelprive.h"
#include <QNetworkReply>
#include <QTextStream>
#include <QTextCodec>
#include <QNetworkRequest>
#include <QUrl>
#include <QDebug>
//定义数据role
enum {
    role_name = 0,
    role_filename,
    role_filedate,
    role_filesize,
    role_filehash,
    role_max,
};

fileModelItem::fileModelItem(){
    //占位符
    QByteArray dummy("-");
    for(int i = 0; i <= role_max; i++)
    {
        m_details.append(dummy);
    }
}

bool fileModelItem::detailAvailable() const{
    return m_details.size() >= role_max;
}

const QByteArray& fileModelItem::filename() const{
    return m_details.at(role_filename);
}

const QByteArray& fileModelItem::filedate() const{
    return m_details.at(role_filedate);
}

const QByteArray& fileModelItem::filesize() const{
    return m_details.at(role_filesize);
}

const QByteArray& fileModelItem::filehash() const{
    return m_details.at(role_filehash);
}

/////////////////////////////////////////////////////////////////////
fileModelProvider::fileModelProvider(QObject* parent){

}

fileModelProvider::~fileModelProvider(){
    int count = m_items.size();
    for(int i=0;i<count;++i){
        delete m_items.at(i);
    }
    m_items.clear();
}

int fileModelProvider::itemCount(){
    return m_items.size();
}

fileModelItem* fileModelProvider::getItembyHash(QByteArray& hash){
    int count = m_items.size();
    for(int i=0;i<count;++i){
       if(m_items.at(i)->filehash() == hash){
            return m_items.at(i);
       }
    }

    return NULL;
}

fileModelItem* fileModelProvider::getItembyName(QByteArray& filename){
    int count = m_items.size();
    for(int i=0;i<count;++i){
       if(m_items.at(i)->filename() == filename){
            return m_items.at(i);
       }
    }
    return NULL;
}

fileModelItem* fileModelProvider::indexAt(int index){
    if (index > m_items.size()){
        return NULL;
    }

    return m_items.at(index);
}

void fileModelProvider::onNetWorkError(QNetworkReply::NetworkError code){
    qDebug()<<QString("onNetWorkError");
}

void fileModelProvider::parseJsonData(const QByteArray &data){

}

void fileModelProvider::onFileListFinished(){
    qDebug()<<QString("onFileListFinished");
    m_reply->disconnect(this);
    if(m_reply->error() != QNetworkReply::NoError)
    {
        qDebug() << "StockProvider::refreshFinished, error - " << m_reply->errorString();
        return;
    }
    else if(m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt() != 200)
    {
        qDebug() << "StockProvider::refreshFinished, but server return - " << m_reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        return;
    }
    //解析json数据
    parseJsonData(m_reply->readAll());
    m_reply->deleteLater();
    m_reply = 0;
}

void fileModelProvider::requestFileList(){
    QString strUrl("http://123.206.46.126:9200/metadata/_search?sort=name,version&from=0&size=10");
    QUrl qurl(strUrl);
    QNetworkRequest req(qurl);

    m_reply = m_nam.get(req);
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(onNetWorkError(QNetworkReply::NetworkError)));
    connect(m_reply, SIGNAL(finished()), this, SLOT(onFileListFinished()));

}


