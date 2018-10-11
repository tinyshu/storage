import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2
Window {
    id: mainWindow
    visible: true;
    x:200
    y:50
    width: 1000;
    height: 530;
    flags: Qt.Window | Qt.FramelessWindowHint;
    color: "#666666";

    Rectangle{
        id: mainWRoot;
        x: 1;
        y: 1;
        width: parent.width - 1;
        height: parent.height - 1;

        TitleBar{
            id: titleBar;
            width: parent.width;
            height: 50;
            mainWindow: mainWindow;
        }

        LeftWidget{
            id: leftWidget;
            anchors.top: titleBar.bottom;
            anchors.left: parent.left;
            //anchors.bottom: bottomBar.top;
            anchors.bottom:parent.bottom
            width: 150;
            //onBtnClicked:musicList.currentViewId = btnId;
        }

        ListModel {
            id: phoneModel;
            ListElement{

                name: "C++程序设计.pdf";
                cost: "2018-01-03";
                manufacturer: "35.27M";
            }
            ListElement{

                name: "算法解析.txt";
                cost: "2017-11-03";
                manufacturer: "1M";
            }
            ListElement{

                name: "QT指南视频.mp4";
                cost: "2017-11-03";
                manufacturer: "517k";
            }
            ListElement{

                name: "GO编程实战.dir";
                cost: "2009-06-03";
                manufacturer: "20M";
            }
        }

        FTableView {
            id: signalsTable
            visible: true
            width: parent.width-leftWidget.width;
            height: parent.height-titleBar.height-bottomBar.height;
            anchors.left: leftWidget.right
            anchors.top: titleBar.bottom
            anchors.topMargin: 1
            anchors.bottomMargin:1
            dataModel: phoneModel
        }
        //底部
        BottomBar{
            id: bottomBar;
            anchors.left: leftWidget.right;
            //anchors.top:leftWidget.bottom
            anchors.bottom: parent.bottom;
            width: parent.width - leftWidget.width;
        }
    }
}
