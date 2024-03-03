import "."
import QtGraphicalEffects 1.12
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

Rectangle {
    property var user: userField.text
    property var password: passwordField.text
    property var sessionIndex: controlPanel.sessionIndex
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: parent.height * 2 / 5 // Bottom 40% of screen
    width: parent.width
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: parent.width
        spacing: 6
        TextInputPanel {
            id: userField
            placeholderText: "user"
        }
        TextInputPanel {
            id: passwordField
            placeholderText: "pass"
            echoMode: TextInput.Password
            passwordCharacter: "•"
            onAccepted: sddm.login(user, password, sessionIndex)
        }
        Component.onCompleted: {
            userField.focus = true;
        }
    }
    ControlPanel {
        id: controlPanel
    }
    // Image {
    //     id: loginButton
    //     source: "images/buttonup.svg"
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.top: parent.bottom
    //     anchors.topMargin: 32
    //     width: 84
    //     height: 28
    //     MouseArea {
    //         anchors.fill: parent
    //         hoverEnabled: true
    //         onEntered: {
    //             parent.source = "images/buttonhover.svg";
    //         }
    //         onExited: {
    //             parent.source = "images/buttonup.svg";
    //         }
    //         onPressed: {
    //             parent.source = "images/buttondown.svg"
    //             sddm.login(user, password, sessionIndex);
    //         }
    //         onReleased: {
    //             parent.source = "images/buttonup.svg";
    //         }
    //     }
    // }
}
