import QtQuick 2.11
import QtQuick.Controls 2.4

Row {
    anchors.top: parent.top
    anchors.right: parent.right
    spacing: 5

    Label {
        id: dateLabel
        color: root.palette.text
        font.pixelSize: 16
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toISOString().slice(0, 10) // ISO Format
        }
    }

    Label {
        id: timeLabel
        color: root.palette.text
        font.pixelSize: 16
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toISOString().slice(11, 16); // 24-hour clock
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
