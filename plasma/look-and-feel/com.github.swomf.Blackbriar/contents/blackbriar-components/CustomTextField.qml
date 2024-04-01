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
    id: root

    height: root.font.pointSize * 6
    width: parent.width

    property string whiteColor: "#FFFFFF"
    property string greyColor: "#808080"
    property string blackColor: "#000000"
    property string disabledColor: "#606060"
    property bool rejected: false

    color: whiteColor
    placeholderTextColor: greyColor
    font.pointSize: 12    
    
    selectByMouse: true
    horizontalAlignment: TextInput.AlignLeft
    renderType: Text.QtRendering

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
        color: blackColor
        border.color: blackColor
        border.width: 2
        radius: 5
    }
 
    Shortcut {
        // Let's consider this shortcut a standard, it's also supported at least by su and sudo
        sequence: "Ctrl+Shift+U"
        enabled: root.activeFocus
        onActivated: root.clear();
    }

    states: [
        State {
            name: "focus"
            when: root.activeFocus
            PropertyChanges {
                target: root.background
                border.color: whiteColor
            }
        },
        State {
            name: "hover"
            when: mouseArea.containsMouse && !(root.activeFocus)
            PropertyChanges {
                target: root.background
                border.color: greyColor
            }
        },
        State {
            name: "unselected"
            when: !(root.activeFocus || mouseArea.containsMouse)
            PropertyChanges {
                target: root.background
                border.color: blackColor
            }
        }//,
        // State {
        //     name: "rejected"
        //     when: rejected
        //     PropertyChanges {
        //         target: root
        //         color: disabledColor
        //     }
        //     PropertyChanges {
        //         target: root.background
        //         border.color: disabledColor
        //     }
        // }
    ]

    function disable() {
        root.readOnly = true
        root.color = disabledColor
        root.background.border.color = disabledColor
    }

    function enable(rejected) {
        root.text = ""
        root.color = whiteColor
        root.readOnly = false

        if (rejected) {
            root.background.border.color = "#FF0000"
            // var shakeAnimation = new NumberAnimation(root, "x",
            //     NumberAnimation.Linear, 0, 5, -5, 1000, 
            //     NumberAnimation.DeleteWhenStopped)
            // shakeAnimation.from = root.x
            // shakeAnimation.to = root.x - 3
            // shakeAnimation.loops = 4
            // shakeAnimation.running = true
        }
    }

    transitions: [
        Transition {
            PropertyAnimation {
                properties: "color, border.color"
                duration: 150
            }
        }
    ]
}