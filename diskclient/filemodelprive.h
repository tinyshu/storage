#ifndef FILEMODELPRIVE_H
#define FILEMODELPRIVE_H
#include <QList>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class fileModelProvider;
//fileModelItem是tableview里一行数据
class fileModelItem{
    friend class fileModelProvider;
public:
    fileModelItem();
    ~fileModelItem(){}

    bool detailAvailable() const;
public:
    const QByteArray& filename() const;
    const QByteArray& filedate() const;
    const QByteArray& filesize() const;
    const QByteArray& filehash() const;
private:


protected:
    QList<QByteArray> m_details;
};

//二维表数据模型
class fileModelProvider: public QObject{
     Q_OBJECT
public:
    fileModelProvider(QObject* parent = 0);
    virtual ~fileModelProvider();
    fileModelItem* getItembyHash(QByteArray& hash);
    fileModelItem* getItembyName(QByteArray& filename);
    fileModelItem* indexAt(int index);
    int itemCount();
protected slots:
    void onFileListFinished();
    void onNetWorkError(QNetworkReply::NetworkError code);
public:
    //向服务器获取文件列表
    void requestFileList();
private:
    void parseJsonData(const QByteArray &data);
protected:
    QList<fileModelItem*> m_items;
    QNetworkAccessManager m_nam;
    QNetworkReply *m_reply;
};

#endif // FILEMODELPRIVE_H
