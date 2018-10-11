#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QQmlContext>
#include "filedatamodel.h"

int main(int argc, char *argv[])
{
#if (QT_VERSION >= QT_VERSION_CHECK(5, 6, 0))
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    QGuiApplication::addLibraryPath("./plugins");
    QQmlApplicationEngine engine;

    //FileDataModel* filemodel = new FileDataModel(&engine);
    //filemodel->requestfileList();
    //engine.rootContext()
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
