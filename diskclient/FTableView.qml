import QtQuick 2.2
import QtQuick.Controls 1.4 as QC14
import QtQuick.Controls.Styles 1.4 as QCS14
import QtQuick.Controls 2.1
import QtQml 2.2
import "JsonPath.js" as JsonPath


Item {
    id: root
    property ListModel dataModel;
    //如何绘制表头列
    Component {
        id: headerDelegate
        Rectangle {
            implicitWidth: 10;
            implicitHeight: 24;
            // gradient: styleData.pressed ? root.hoverG : (styleData.containsMouse ? root.hoverG: root.normalG);
            border.width: 1;
            border.color: "gray";
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 4;
                //anchors.right: parent.right;
                anchors.rightMargin: 4;
                text: styleData.value;
                color: styleData.pressed ? "#A9A9A9" : "#A9A9A9";
                font.bold: true;
            }
        }
    }

    //行背景绘制组件
    Component{
        id: rowDelegate
        Rectangle {
            id:rowRectDelegate
            height: 25
            //border.width:1
            color: itemArea.containsMouse ? "#EAF5FF" : "#FEFEFE";

            MouseArea{
                id: itemArea;
                anchors.fill: parent;
                hoverEnabled: true;
            }
        }
    }
    //item代理组件
    Component {
        id: itemDelegate
        //延时加载组件
        Loader {
            id: itemLoader
            anchors.fill: parent

            visible: status === Loader.Ready
            sourceComponent: {
                var role = styleData.role;
                if(role === "name")
                {
                    var extend = fileExtentName(styleData.value)
                    //console.log(extend)
                    if(extend==="dir"){
                        return fileCellComponent;
                    }
                    else if(extend==="pdf"){
                        geturl()
                        return pdfCellComponent
                    }
                    else if(extend==="txt"){
                        return txtFileComponent
                    }
                    else{
                        return unKnownComponent
                    }
                }
                else
                    return norMalCellComponent

            }

            Component {
                id: fileCellComponent

                Item{
                    y:8
                    Text{
                        text: styleData.value;
                        font.pixelSize: 10
                        anchors.left: im.right
                        anchors.leftMargin: 3
                        anchors.verticalCenter:im.verticalCenter
                        color: styleData.selected ? "#D3D3D3" : styleData.textColor;
                        elide: styleData.elideMode;
                    }

                    Image {
                        id: im
                        source: "qrc:///topwidget/folder.png"
                        width: 12; height: 12

                    }
                }
            }

            Component {
                id: pdfCellComponent
                Item{
                    y:8
                    Text{
                        text: styleData.value;
                        font.pixelSize: 10
                        anchors.left: im.right
                        anchors.leftMargin: 3
                        //anchors.top: im.top
                        anchors.verticalCenter: im.verticalCenter
                        color: styleData.selected ? "#D3D3D3" : styleData.textColor;
                        elide: styleData.elideMode;
                    }

                    Image {
                        id: im
                        source: "qrc:///topwidget/pdf.png"
                        width: 12; height: 12
                    }
                }
            }

            Component {
                id: txtFileComponent
                Item{
                    y:8
                    Text{
                        text: styleData.value;
                        font.pixelSize: 10
                        anchors.left: im.right
                        anchors.leftMargin: 3
                        //anchors.top: im.top
                        anchors.verticalCenter: im.verticalCenter
                        color: styleData.selected ? "#D3D3D3" : styleData.textColor;
                        elide: styleData.elideMode;
                    }

                    Image {
                        id: im
                        source: "qrc:///topwidget/txt.png"
                        width: 12; height: 12
                    }
                }
            }

            Component {
                id: unKnownComponent
                Item{
                    y:8
                    Text{
                        text: styleData.value;
                        font.pixelSize: 10
                        anchors.left: im.right
                        anchors.leftMargin: 3
                        //anchors.top: im.top
                        anchors.verticalCenter: im.verticalCenter
                        color: styleData.selected ? "#D3D3D3" : styleData.textColor;
                        elide: styleData.elideMode;
                    }

                    Image {
                        id: im
                        source: "qrc:///topwidget/wenhao.png"
                        width: 12; height: 12
                    }
                }
            }

            Component{
                id:norMalCellComponent

                Text{
                    y:8
                    text: styleData.value;
                    font.pixelSize: 10
                    anchors.leftMargin: 2
                    //anchors.verticalCenter: parent.verticalCenter
                    color: styleData.selected ? "#D3D3D3" : styleData.textColor;
                    elide: styleData.elideMode;
                }
            }

        }
    }

    //TableView组件
    QC14.TableView {
        id: phoneTable;
        anchors.fill: parent
        visible: parent.visible
        headerDelegate: headerDelegate
        rowDelegate: rowDelegate
        itemDelegate: itemDelegate
        model: root.dataModel
        QC14.TableViewColumn{ role: "name"  ; title: "文件名" ; width: 400; elideMode: Text.ElideRight;}
        QC14.TableViewColumn{ role: "cost" ; title: "修改时间" ; width: 150; }
        QC14.TableViewColumn{ role: "manufacturer" ; title: "大小" ; width: 150; }
    }

    function fileExtentName(filename){
        var index1 = filename.lastIndexOf(".")
        var index2 = filename.length
        if (index1 ===-1){
            return ""
        }

        var extend = filename.substring(index1+1,index2)
        return extend
    }

    function geturl(){
        var doc = new XMLHttpRequest();
        doc.onreadystatechange = function() {
            if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {

                //console.log("Headers -->");
                //console.log(doc.getAllResponseHeaders ());
                //console.log("Last modified -->");
                //console.log(doc.getResponseHeader ("Last-Modified"));

            }else if (doc.readyState == XMLHttpRequest.DONE) {

                var object = JSON.parse(doc.responseText.toString());
                print(JSON.stringify(object, null, 2));

                var hitsarray = object["hits"]["hits"];
                var arraylen = hitsarray.length;
                print(arraylen)
                for(var i = 0; i < arraylen; i++){
                    var meta = hitsarray[i]._source;
                    print(meta.name);

//                    //json字符串
//                    var json = [];
//                    var row1 = {};
//                    row1.name= meta.name;
//                    row1.cost = "2018-01-03";
//                    row1.manufacturer = String(meta.size)
//                    json.push(row1);


//                    dataModel.append(json)
                }

            }

        }


        // curl -v http://127.0.0.1:9200/metadata/objects/test6_1/_source
        //doc.open("GET", "http://123.206.46.126:9200/metadata/_search?sort=name,version&from=0&size=10");
        //doc.open("GET", "http://123.206.46.126:2345/versions/test6");
        //doc.send();
    }

}
