import QtQuick 2.4
import QtQuick.Window 2.0
import QtQuick.Controls 2.1
import QtQuick.Controls.Styles 1.4


Rectangle {
    id: titleRect;
    height: 50;
    width: 800;
    //color: "#C62F2F";
    color: "#EEF0F6";
    property Window mainWindow: null;

    MouseArea { //为窗口添加鼠标事件
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton //只处理鼠标左键
        property point clickPos: "0,0"
        onPressed: { //接收鼠标按下事件
            clickPos  = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: { //鼠标按下后改变位置
            if(mainWindow == null || mainWindow.visibility == Window.FullScreen)
                return;
            //鼠标偏移量
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

            //如果mainwindow继承自QWidget,用setPos
            mainWindow.setX(mainWindow.x+delta.x)
            mainWindow.setY(mainWindow.y+delta.y)
        }
        onDoubleClicked: {
            if(mainWindow.visibility == Window.FullScreen)
                mainWindow.showNormal();
            else{
               mainWindow.visibility = Window.FullScreen;
            }
        }
    }

    //添加标题图片 logo
//    Image{
//        id: titleImg
//        cache: true;
//        sourceSize.width: 120;
//        sourceSize.height: 25;
//        anchors.top: parent.top;
//        anchors.topMargin: 16;
//        anchors.left: parent.left;
//        anchors.leftMargin: 15;
//        source: "qrc:///images/title1.png"
//    }

     Rectangle{
         id: titleTexe
         width: 120;
         height: 25;
         anchors.top: parent.top;
         anchors.topMargin: 16;
         anchors.left: parent.left;
         anchors.leftMargin: 10
         anchors.verticalCenter: parent.verticalCenter;
         color: "#EEF0F6"

         Text {
              text: "xxx网盘-shuyi"
              font.family: "Helvetica"
              font.pointSize: 14
              color: "#666666"
              styleColor : "black"
              font.bold : true
              style: Text.Sunken
          }
     }

    //添加搜索栏
    Row{
        id: searchRow
        anchors.left: titleTexe.right;
        anchors.leftMargin: 15;
        anchors.verticalCenter: parent.verticalCenter;
        spacing: 15;

        //搜索条
        Rectangle{
            width: 100;
            height: 22;
            border.width: 1;
            border.color: "#505050";
            color: "#E3E3E3";
            radius: 20;
            TextInput{
                id: searchText
                anchors.top: parent.top;
                anchors.topMargin: 5;
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                width: parent.width - 35;
                clip: true;
                color: "black";
                font.pointSize: 10
                property string preText: "";
                onEditingFinished:{
                    if(text == "" || preText == text)
                        return;
                    preText = text;
                    musicManager.keyword = searchText.text;
                    musicManager.startRequest = true;
                }
                cursorDelegate: Rectangle{
                    id: searchCursor
                    width: 1;
                    height: searchText.height;
                    border.width: 1
                    border.color: "white";
                    Timer{
                        id: shinInterval;
                        interval: 500;
                        running: true
                        repeat: true;
                        onTriggered: {
                            searchCursor.visible = !searchCursor.visible;
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked: searchText.focus = true;

                }
                /*MusicManager{
                    id: musicManager;
                    type: MusicManager.Search;
                    onFinished: {
                        if(musicCount <= 0){
                            musicList.currentViewId = -1;
                            errorText.text = "没有搜索到歌曲!"
                        }else{
                            musicList.currentViewId = 10;
                            detailView.refresh(musicManager);
                        }
                    }
                }*/
            }

            Image{
                anchors.verticalCenter: parent.verticalCenter;
                anchors.right: parent.right;
                anchors.rightMargin: 2;
                width: 16; height: 16
                source: "qrc:///topwidget/btnSearch64.png";
                opacity: searchArea.containsMouse ? 1.0 : 0.7;

                MouseArea{
                    id: searchArea;
                    anchors.fill: parent;
                    hoverEnabled: true;
                    onClicked: {
                        musicManager.keyword = searchText.text;
                        musicManager.startRequest = true;
                    }
                }

            }
        }
    }

    Row{
        id:btnDiskRow
        spacing: 15;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left:searchRow.right;
        anchors.leftMargin: 20;


    }
    //添加换肤等图标
    Row{
        id: btnSkinRow
        spacing: 15;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: btnWindow.left;
        anchors.rightMargin: 20;

        //皮肤
        Image{
            id: btnSkin;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:///topwidget/btnSkin64.png";
            width: 16; height: 16
            opacity: skinArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: skinArea;
                anchors.fill: parent;
                hoverEnabled: true;

            }
        }

        //信息
        Image{
            id: btnMessage;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:///topwidget/btnMessage64.png";
            width: 16; height: 16
            opacity: messageArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: messageArea;
                anchors.fill: parent;
                hoverEnabled: true;

            }
        }

        //设置
        Image{
            id: btnSetting;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:///topwidget/btnSetting64.png";
            width: 16; height: 16
            opacity: settingArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: settingArea;
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }

        //分隔条
        Rectangle{
            width: 10;
            height: 25;
            color: "#EEF0F6";
            Rectangle{
                anchors.horizontalCenter: parent.horizontalCenter;
                width: 1;
                height: parent.height;
                //border.width: 1;
                color: "#DDDFE5";
            }
        }
    }

    //添加控制最大最小关闭按钮
    Row{
        id: btnWindow
        spacing: 12;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right;
        anchors.rightMargin: 20;


        //最小化
        Image{
            id: btnMini;
            anchors.verticalCenter: parent.verticalCenter;
            width: 16; height: 16
            source: "qrc:///topwidget/btnMini64.png";
            opacity: miniArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: miniArea;
                anchors.fill: parent;
                hoverEnabled: true;
                onReleased: {
                    if(mainWindow == null)
                        return;
                    mainWindow.visibility = Window.Minimized;
                }
            }
        }

        Image{
            id: btnMax;
            anchors.verticalCenter: parent.verticalCenter;
            width: 16; height: 16
            source: "qrc:///topwidget/btnMax64.png";
            opacity: miniArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: maxiArea
                anchors.fill: parent;
                hoverEnabled: true;
                onReleased: {
                    if(mainWindow == null)
                        return;
                    if(mainWindow.visibility == Window.FullScreen)
                        mainWindow.showNormal();
                    else
                        mainWindow.visibility = Window.FullScreen;
                }
            }
        }

        //最大化
//        Rectangle{
//            width: 20;
//            height: 20;
//            color: "#C62F2F";
//            Rectangle{
//                id: btnMaximum;
//                anchors.centerIn: parent;
//                width: 15;
//                height: 10;
//                border.width: 1;
//                border.color: maxiArea.containsMouse ? "#FFFFFF" : "#EEF0F6";
//                color: "#C62F2F";
//                radius: 2;
//            }
//            MouseArea{
//                id: maxiArea
//                anchors.fill: parent;
//                hoverEnabled: true;
//                onReleased: {
//                    if(mainWindow == null)
//                        return;
//                    if(mainWindow.visibility == Window.FullScreen)
//                        mainWindow.showNormal();
//                    else
//                        mainWindow.visibility = Window.FullScreen;
//                }
//            }

//        }
        //关闭
        Image{
            id: btnClose;
            anchors.verticalCenter: parent.verticalCenter;
            width: 16; height: 16
            source: "qrc:///topwidget/btnClose64.png";

            opacity: closeArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: closeArea;
                anchors.fill: parent;
                hoverEnabled: true;
                onReleased: {
                    if(mainWindow == null)
                        return;
                    mainWindow.close();
                }
            }
        }
     }

}
