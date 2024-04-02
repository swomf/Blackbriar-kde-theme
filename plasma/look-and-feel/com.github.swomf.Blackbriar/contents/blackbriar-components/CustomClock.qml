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
        color: "#E0E0E0"
        font.pixelSize: root.fontSize
        renderType: Text.QtRendering
        function updateTime() {
            text = Qt.formatDateTime(new Date(), "yyyy-MM-dd")
        }
    }

    Label {
        id: timeLabel
        color: "#E0E0E0"
        font.pixelSize: root.fontSize / 2
        renderType: Text.QtRendering
        function updateTime() {
            text = Qt.formatDateTime(new Date(), "hh:mm");
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
