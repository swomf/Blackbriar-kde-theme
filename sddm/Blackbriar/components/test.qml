import QtQuick 2.4
import QtQuick.Window 2.2

Window {
    width: 640
    height: 480
    visible: true

    ListModel {
        id: model
        ListElement {
            name:'abc'
            number:'123'
        }
        ListElement {
            name:'efg'
            number:'456'
        }
        ListElement {
            name:'xyz'
            number:'789'
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        model: model
        delegate: Component {
            Item {
                width: parent.width
                height: 40
                Column {
                    Text { text: 'Name:' + name }
                    Text { text: 'Number:' + number }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: list.currentIndex = index
                }
            }
        }
        highlight: Rectangle {
            color: 'grey'
            Text {
                anchors.centerIn: parent
                text: 'Hello ' + model.get(list.currentIndex).name
                color: 'white'
            }
        }
        focus: true
        onCurrentItemChanged: console.log(model.get(list.currentIndex).name + ' selected')
    }
}