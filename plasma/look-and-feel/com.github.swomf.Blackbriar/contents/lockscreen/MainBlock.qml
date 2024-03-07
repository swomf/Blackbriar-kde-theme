/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>
 
    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../components"

SessionManagementScreen {

    readonly property alias mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: false
    property alias echoMode: passwordBox.echoMode
    Layout.fillWidth: true


    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    signal passwordResult(string password)

    function startLogin() {
        const password = passwordBox.text
        passwordResult(password);
    }

    Item {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        width: Math.min(parent.width, 400)
        RowLayout {
            anchors.centerIn: parent
            width: parent.width - units.largeSpacing * 3

            PlasmaComponents3.TextField {
                id: passwordBox
                font.pointSize: PlasmaCore.Theme.defaultFont.pointSize + 1
                Layout.fillWidth: true

                placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
                focus: true
                echoMode: TextInput.Password
                passwordCharacter: "•" // U+2022 is centered, unlike the default U+25CF
                inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData
                                  | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                enabled: !authenticator.graceLocked
                revealPasswordButtonShown: true

                onAccepted: {
                    if (lockScreenUiVisible) {
                        startLogin();
                    }
                }

                //if empty and left or right is pressed change selection in user switch
                //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
                Keys.onPressed: {
                    if (event.key == Qt.Key_Left && !text) {
                        userList.decrementCurrentIndex();
                        event.accepted = true
                    }
                    if (event.key == Qt.Key_Right && !text) {
                        userList.incrementCurrentIndex();
                        event.accepted = true
                    }
                }

                Connections {
                    target: root
                    function onClearPassword() {
                        passwordBox.forceActiveFocus()
                        passwordBox.text = "";
                    }
                }
            }
        }
    }
}
