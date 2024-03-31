// This file was created heavily from
// https://api.kde.org/plasma/libplasma/html/PasswordField_8qml_source.html
//   (SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>)
//   (SPDX-License-Identifier: LGPL-2.0-or-later)
// but it also used sddm-sugar-dark by Marian Arlt (GPLv3) and
// Rokin05's Rokin05-sddm-themes (GPLv3-or-later)

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4

TextField {
    id: passwordField

    property bool showPassword: false
    property url passwordHideSource: Qt.resolvedUrl("artwork/password-hide.svg")
    property url passwordShowSource: Qt.resolvedUrl("artwork/password-show.svg")
    placeholderText: "pass"
    placeholderTextColor: "#808080"
    font.pointSize: 12
    // right side limit
    rightPadding: togglePasswordButton.width + passwordField.font.pointSize

    passwordCharacter: "•" // U+2022 is centered, unlike the default U+25CF
    
    // like onAccepted, but keeping the onAccepted name would make syntax
    // ambiguous --- `onAccepted: { ...` versus `onAccepted: function () {...`
    property var callback: function() {}
    
    text: ""
    color: "#e0e0e0"
    height: passwordField.font.pointSize * 6
    width: parent.width

    selectByMouse: true
    echoMode: showPassword ? TextInput.Normal : TextInput.Password
    horizontalAlignment: TextInput.AlignLeft
    renderType: Text.QtRendering

    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData

    MouseArea {
        // this is to color the border when hovering
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        // workaround to put under parent and act like a textfield on hover
        z: -1 // this ensures it is behind its parent so we can click textfield
        cursorShape: Qt.IBeamCursor // makes hovering look like an I
    }
    background: Rectangle {
        color: "#000000"
        border.color: "#000000"
        border.width: 2
        radius: 5
    }

    Keys.onReturnPressed: event => {
        if (passwordField.activeFocus) {
            callback()
        }
    }

    Keys.onPressed: event => {
        if (event.matches(StandardKey.Undo)) {
            // Disable undo action for security reasons
            // See QTBUG-103934
            event.accepted = true
        }
    }
 
    Shortcut {
        // Let's consider this shortcut a standard, it's also supported at least by su and sudo
        sequence: "Ctrl+Shift+U"
        enabled: passwordField.activeFocus
        onActivated: passwordField.clear();
    }

    states: [
        State {
            name: "focus"
            when: passwordField.activeFocus
            PropertyChanges {
                target: passwordField.background
                border.color: "#E0E0E0"
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse && !(passwordField.activeFocus)
            PropertyChanges {
                target: passwordField.background
                border.color: passwordField.placeholderTextColor
            }
        },
        State {
            name: "neither"
            when: !(passwordField.activeFocus || mouseArea.containsMouse)
            PropertyChanges {
                target: passwordField.background
                border.color: "#000000"
            }
        }
    ]

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "color, border.color"
                duration: 150
            }
        }
    ]

    Item {
        id: togglePasswordButton
        anchors.right: parent.right
        anchors.rightMargin: passwordField.font.pointSize * 0.6
        anchors.verticalCenter: parent.verticalCenter
        width: passwordField.font.pointSize * 1.5
        height: width

        Image {
            id: toggleImage
            anchors.centerIn: parent
            height: parent.height
            width: parent.width
            source: passwordField.showPassword ? passwordHideSource : passwordShowSource
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            anchors.fill: parent
            onClicked: passwordField.showPassword = !passwordField.showPassword
        }
    }
}