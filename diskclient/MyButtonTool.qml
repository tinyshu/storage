//import QtQuick 2.6
//import QtGraphicalEffects 1.0

//Item {
//    id : mybutton
//    width: 50
//    height: 30

//    signal clicked();

//    Rectangle {
//        id : bgrect;
//        y : 20
//        x : 1
//        color: "#5CB85C";
//        width: mybutton.width-2;
//        height: mybutton.height-25
//        //radius: height/2
//    }

//    DropShadow {
//        id : shadow
//        anchors.fill: bgrect
//        horizontalOffset: 2
//        verticalOffset: 12
//        //radius: 8.0
//        samples: 17
//        color: "#999999"
//        source: bgrect
//    }


//    Rectangle{
//        id : toprect
//        color: "#5CB85C"
//        width: mybutton.width;
//        height: mybutton.height-2
//        radius: height/3

//        MouseArea {
//            id: mouseArea
//            anchors.fill: parent
//            hoverEnabled : true
//            onClicked: {
//               animation.start();
//               mybutton.clicked();
//            }
//            onEntered: {
//                toprect.color = "#3e8e41";
//                bgrect.color = "#3e8e41";
//            }
//            onExited: {
//                toprect.color = "#5CB85C";
//                bgrect.color = "#5CB85C";
//            }

//        }

//    }

//    Text {
//        id: mytext
//        anchors.centerIn: toprect
//        text: qsTr("我的网盘")
//        color: "#ffffff"
//        font.pixelSize : toprect.height/2
//    }


//    SequentialAnimation {

//              id : animation
//              NumberAnimation { target: toprect; property: "y"; to: toprect.x+2; duration: 100 }
//              NumberAnimation { target: toprect; property: "y"; to: toprect.x-2; duration: 100 }
//          }

//}
import QtQuick 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Rectangle{
    id: myBRoot;
    width: 200;
    height: 34;
    color: myBArea.containsMouse ? "#E6E7EA" : "#F5F5F7";

    property var myText: "";
    property var source: "";
    property var leftSpace: 10;
    property var spacing: 10;
    signal btnClicked();

    MouseArea{
        id: myBArea;
        anchors.fill: parent;
        hoverEnabled: true;
        onClicked: {
            myBRoot.btnClicked();
        }
    }

    Row{
        height: 30;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: parent.left;
        anchors.leftMargin: myBRoot.leftSpace;
        spacing: myBRoot.spacing;

        Image{
            id: mBIcon;
            width: 20;
            height: 20;
            anchors.verticalCenter: parent.verticalCenter;
            source: myBRoot.source;
            opacity: myBArea.containsMouse ? 1.0 : 0.7;
        }

        Text{
            id: mBText
            anchors.verticalCenter: parent.verticalCenter;
            opacity: myBArea.containsMouse ? 1.0 : 0.7;
            text: myBRoot.myText;
        }
    }

}
