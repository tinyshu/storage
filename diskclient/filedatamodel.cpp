#include "filedatamodel.h"
#include "filemodelprive.h"
#include <QVector>
#include <QHash>
#include <QFile>

FileDataModel::FileDataModel(QObject* parent)
    :QAbstractListModel(parent)
{
    m_modelProvider = new fileModelProvider(this);
}

FileDataModel::~FileDataModel(){
    if(!m_modelProvider){
        delete m_modelProvider;
    }
}

int FileDataModel::rowCount(const QModelIndex &parent) const{
    return 0;
}

QVariant FileDataModel::data(const QModelIndex &index, int role) const{
    return QVariant();
}

QHash<int, QByteArray> FileDataModel::roleNames() const{
    return QHash<int, QByteArray>();
}

void FileDataModel::requestfileList(){
    m_modelProvider->requestFileList();
}
