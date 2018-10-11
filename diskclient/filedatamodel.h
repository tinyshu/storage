#ifndef FILEDATAMODEL_H
#define FILEDATAMODEL_H

#include <QAbstractListModel>
#include <QObject>
class fileModelProvider;
class FileDataModel: public QAbstractListModel
{
    Q_OBJECT
public:
    FileDataModel(QObject* parent = 0);
    ~FileDataModel();
public:
    //实现QAbstractListModel接口
    int rowCount(const QModelIndex &parent) const;
    QVariant data(const QModelIndex &index, int role) const;
    QHash<int, QByteArray> roleNames() const;

    void requestfileList();
private:
    fileModelProvider* m_modelProvider;
};

#endif // FILEDATAMODEL_H
