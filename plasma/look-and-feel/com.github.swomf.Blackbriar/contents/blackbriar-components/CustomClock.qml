import QtQuick 2.11
import QtQuick.Controls 2.4

Column {
    id: root
    state: lockScreenRoot.uiVisible ? "off" : "on"
    property int fontSize: parent.height * 0.06
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: -5

    Label {
        id: dateLabel
        color: root.palette.text
        font.pixelSize: root.fontSize
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toISOString().slice(0, 10) // ISO Format
        }
    }

    Label {
        id: timeLabel
        color: root.palette.text
        font.pixelSize: root.fontSize / 2
        renderType: Text.QtRendering
        function updateTime() {
            text = new Date().toISOString().slice(11, 16); // 24-hour clock
        }
    }

    transitions: [
        Transition {
            from: "off"
            to: "on"
            //Note: can't use animators as they don't play well with parallelanimations
            NumberAnimation {
                targets: [dateLabel, timeLabel]
                property: "opacity"
                from: 0
                to: 1
                duration: 500 // milliseconds
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "on"
            to: "off"
            NumberAnimation {
                targets: [dateLabel, timeLabel]
                property: "opacity"
                from: 1
                to: 0
                duration: 500 // milliseconds
                easing.type: Easing.OutCubic
            }
        }
    ]

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
