import QtQuick 2.15
Rectangle {
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    height: parent.height * 23 / 40 // Slight offset from halfway mark. Tune if needed
    width: parent.width
    AnimatedImage {
        source: "custom-picture/" + config.picture
        width: config.pictureWidth
        height: config.pictureHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }
}