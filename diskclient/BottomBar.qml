import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle{
    id: bBarRoot;
    height: 35;
    width: parent;
    color: "#EEF0F6"
    //分隔条
    Rectangle{
        id: bBSeparetor;
        width: parent.width;
        height:1;
        border.width: 1.5;
        anchors.top: parent.top;
        anchors.left: parent.left;
        color: "#E1E1E2";
    }

    Rectangle{
        id: versionTexe
        width: 30;
        //height: 35;
        anchors.top: parent.top;
        anchors.topMargin: 16;
        anchors.left: parent.left;
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter;
        color: "#EEF0F6"

        Text {
            text: "v1.0.0"
            font.family: "Helvetica"
            font.pointSize: 10
            color: "#666666"
            font.bold : true
            anchors.verticalCenter: parent.verticalCenter;
        }
    }

    Row{
        id: btnbomRow
        spacing: 15;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.right: parent.right;
        anchors.rightMargin: 30;

        //备份button
        Image{
            id: btnBack;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:///topwidget/back.png";
            width: 16; height: 16
            opacity: backArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: backArea;
                anchors.fill: parent;
                hoverEnabled: true;

            }
        }

        Image{
            id: btnlock;
            anchors.verticalCenter: parent.verticalCenter;
            source: "qrc:///topwidget/lock.png";
            width: 16; height: 16
            opacity: lockArea.containsMouse ? 1.0 : 0.7;
            MouseArea{
                id: lockArea;
                anchors.fill: parent;
                hoverEnabled: true;

            }
        }
    }
}
