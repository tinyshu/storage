import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle{
    id: lWRoot;
    width: 100;
    height: 530;
    color: "#F5F5F7";
    signal btnClicked(var btnId);

    //右边分割线
    Rectangle{
        id: lWRightSeparator;
        width: 1;
        height: parent.height;
        color:  "#E1E1E2";
        anchors.top: parent.top;
        anchors.right: parent.right;
    }

    //主列表
    Column{
        id: mainList;
        width: parent.width - lWRightSeparator.width;
        height: parent.height;
        anchors.top: parent.top;
        anchors.left: parent.left;
        spacing: 20;

        Column{
            width: parent.width;
//            Text{
//                id: toolsPart;
//                width: parent.width;
//                height: 34;
//                text: "  功能栏";
//                color: "#5C5C5C";
//                verticalAlignment: Text.AlignVCenter;
//            }

            MyButton{
                id: fdmyDiskPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/mydisk64.png";
                myText: "我的网盘";
                onBtnClicked: lWRoot.btnClicked(0);
            }

            MyButton{
                id: fdtransPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/translist64.png";
                myText: "传输列表";
                onBtnClicked: lWRoot.btnClicked(0);
            }
        }

        //分隔条
        Rectangle{
            width: parent.width;
            height: 1;
            color: "#EEF0F6";
            Rectangle{
                anchors.verticalCenter: parent.verticalCenter;
                width: parent.width;
                height: 1;
                //border.width: 1;
                color: "#DDDFE5";
            }
        }


        Column{
            width: parent.width;

//            Text{
//                id: recommendPart;
//                width: parent.width;
//                height: 34;
//                text: "  应用列表";
//                color: "#5C5C5C";
//                verticalAlignment: Text.AlignVCenter;
//            }

            MyButton{
                id: fdMusicPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnAll64.png";
                myText: "全部";
                onBtnClicked: lWRoot.btnClicked(0);
            }
            MyButton{
                id: fmPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnPic64.png";
                myText: "图片";
               onBtnClicked: lWRoot.btnClicked(1);
            }
            MyButton{
                id: mvPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnDoc64.png";
                myText: "文档";
               onBtnClicked: lWRoot.btnClicked(2);
            }
            MyButton{
                id: friendsPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnMus64.png";
                myText: "音乐";
                onBtnClicked: lWRoot.btnClicked(3);
            }

            MyButton{
                id: seedPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnSeed64.png";
                myText: "种子";
                onBtnClicked: lWRoot.btnClicked(3);
            }

            MyButton{
                id: otherPart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnOther64.png";
                myText: "其他";
                onBtnClicked: lWRoot.btnClicked(3);
            }

            MyButton{
                id: privatePart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnPrivate64.png";
                myText: "隐藏空间";
                onBtnClicked: lWRoot.btnClicked(3);
            }

            MyButton{
                id: shapePart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnShaper64.png";
                myText: "我的分享";
                onBtnClicked: lWRoot.btnClicked(3);
            }

            MyButton{
                id: deletePart;
                width: parent.width;
                height: 34;
                source: "qrc:///topwidget/btnDelete_64.png";
                myText: "回收站";
                onBtnClicked: lWRoot.btnClicked(3);
            }
        }
    }
}
