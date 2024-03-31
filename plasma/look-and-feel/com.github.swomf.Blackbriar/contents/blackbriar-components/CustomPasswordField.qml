// This file was created heavily from
// https://api.kde.org/plasma/libplasma/html/PasswordField_8qml_source.html
//   (SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>)
//   (SPDX-License-Identifier: LGPL-2.0-or-later)
// but it also used sddm-sugar-dark by Marian Arlt (GPLv3) and
// Rokin05's Rokin05-sddm-themes (GPLv3-or-later)

import QtQuick 2.11
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
// also depends on blackbriar-components CustomTextField.qml

CustomTextField {
    id: passwordField

    property bool showPassword: false
    property url passwordHideSource: Qt.resolvedUrl("artwork/password-hide.svg")
    property url passwordShowSource: Qt.resolvedUrl("artwork/password-show.svg")
    placeholderText: "pass"

    // right side limit so text doesn't go under eye symbol
    rightPadding: togglePasswordButton.width + passwordField.font.pointSize

    passwordCharacter: "•" // U+2022 is centered, unlike the default U+25CF
    
    // like onAccepted, but keeping the onAccepted name would make syntax
    // ambiguous --- `onAccepted: { ...` versus `onAccepted: function () {...`
    property var callback: function() {}
    
    selectByMouse: true
    echoMode: showPassword ? TextInput.Normal : TextInput.Password
    horizontalAlignment: TextInput.AlignLeft
    renderType: Text.QtRendering

    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData

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