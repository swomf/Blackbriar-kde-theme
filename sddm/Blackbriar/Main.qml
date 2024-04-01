/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import Qt5Compat.GraphicalEffects

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.kirigami 2.20 as Kirigami

import QtQuick 2.11
import QtQuick.Controls 2.4

import org.kde.breeze.components
import "blackbriar-components"

// TODO: Once SDDM 0.19 is released and we are setting the font size using the
// SDDM KCM's syncing feature, remove the `config.fontSize` overrides here and
// the fontSize properties in various components, because the theme's default
// font size will be correctly propagated to the login screen

Item {
    id: root

    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    Kirigami.Theme.inherit: false

    width: 1600
    height: 900

    property string notificationMessage

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    // P5Support.DataSource {
    //     id: executable
    //     engine: "executable"
    //     connectedSources: []
    //     onNewData: disconnectSource(sourceName)

    //     function exec(cmd) {
    //         executable.connectSource(cmd)
    //     }
    // }

    P5Support.DataSource {
        id: keystateSource
        engine: "keystate"
        connectedSources: "Caps Lock"
    }

    Item {
        id: wallpaper
        anchors.fill: parent
        Repeater {
            model: screenModel

            Background {
                x: geometry.x; y: geometry.y; width: geometry.width; height: geometry.height
                sceneBackgroundType: config.type
                sceneBackgroundColor: config.color
                sceneBackgroundImage: config.background
            }
        }
    }

    MouseArea {
        id: loginScreenRoot
        anchors.fill: parent

        property bool uiVisible: false
        property bool blockUI: mainStack.depth > 1 || userListComponent.mainPasswordBox.text.length > 0 || inputPanel.keyboardActive || config.type !== "image"

        hoverEnabled: true
        drag.filterChildren: true
        onPressed: uiVisible = true;
        onPositionChanged: uiVisible = true;
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
            } else if (uiVisible) {
                fadeoutTimer.restart();
            }
        }
        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
                uiVisible = true;
            } else {
                fadeoutTimer.restart();
            }
        }

        Keys.onPressed: event => {
            uiVisible = true;
            event.accepted = false;
        }

        //takes one full minute for the ui to disappear
        Timer {
            id: fadeoutTimer
            running: true
            interval: 60000
            onTriggered: {
                if (!loginScreenRoot.blockUI) {
                    userListComponent.mainPasswordBox.showPassword = false;
                    loginScreenRoot.uiVisible = false;
                }
            }
        }
        WallpaperFader {
            visible: config.type === "image"
            anchors.fill: parent
            state: loginScreenRoot.uiVisible ? "on" : "off"
            source: wallpaper
            mainStack: mainStack
            footer: footer
            clock: clock
        }

        CustomMiniClock {
            id: clock
            anchors.right: parent.right
            anchors.rightMargin: Kirigami.Units.largeSpacing
            anchors.top: parent.top
            anchors.topMargin: Kirigami.Units.smallSpacing
        }

        Column {
            id: mainStack
            property string lastUserName: userModel.lastUser

            height: root.height + Kirigami.Units.gridUnit * 3
            width: parent.width

            CustomGif {
                z: 5
                height: 400
                width: 400
                anchors {
                    bottom: parent.verticalCenter
                    // bottomMargin: 40
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Layout.alignment: Qt.AlignCenter

            Login {
                id: userListComponent
                z: 5
                desiredSession: selectDEButton.currentIndex
                width: parent.width / 7
                anchors {
                    top: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                loginFunction: function(username, password) {
                    sddm.login(username, password, selectDEButton.currentIndex)
                }
                // loginScreenUiVisible: loginScreenRoot.uiVisible
            }

            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                }
            }

            readonly property real zoomFactor: 1.5
        }

        VirtualKeyboardLoader {
            id: inputPanel

            z: 1

            screenRoot: root
            mainStack: mainStack
            mainBlock: userListComponent
            passwordField: userListComponent.mainPasswordBox
        }

        DropShadow {
            id: logoShadow
            anchors.fill: logo
            source: logo
            visible: !softwareRendering && config.showlogo === "shown"
            horizontalOffset: 1
            verticalOffset: 1
            radius: 6
            samples: 14
            spread: 0.3
            color : "black" // shadows should always be black
            opacity: loginScreenRoot.uiVisible ? 0 : 1
            Behavior on opacity {
                //OpacityAnimator when starting from 0 is buggy (it shows one frame with opacity 1)"
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Image {
            id: logo
            visible: config.showlogo === "shown"
            source: config.logo
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: footer.top
            anchors.bottomMargin: Kirigami.Units.largeSpacing
            asynchronous: true
            sourceSize.height: height
            opacity: loginScreenRoot.uiVisible ? 0 : 1
            fillMode: Image.PreserveAspectFit
            height: Math.round(Kirigami.Units.gridUnit * 3.5)
            Behavior on opacity {
                // OpacityAnimator when starting from 0 is buggy (it shows one frame with opacity 1)"
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.InOutQuad
                }
            }
        }

        // Note: Containment masks stretch clickable area of their buttons to
        // the screen edges, essentially making them adhere to Fitts's law.
        // Due to virtual keyboard button having an icon, buttons may have
        // different heights, so fillHeight is required.
        //
        // Note for contributors: Keep this in sync with LockScreenUi.qml footer.
        RowLayout {
            id: footer
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: Kirigami.Units.smallSpacing
            }
            spacing: Kirigami.Units.smallSpacing

            Behavior on opacity {
                OpacityAnimator {
                    duration: Kirigami.Units.longDuration
                }
            }

            PlasmaComponents3.ToolButton {
                id: virtualKeyboardButton

                text: i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Button to show/hide virtual keyboard", "Virtual Keyboard")
                font.pointSize: config.fontSize
                icon.name: inputPanel.keyboardActive ? "input-keyboard-virtual-on" : "input-keyboard-virtual-off"
                onClicked: {
                    // Otherwise the password field loses focus and virtual keyboard
                    // keystrokes get eaten
                    userListComponent.mainPasswordBox.forceActiveFocus();
                    inputPanel.showHide()
                }
                visible: inputPanel.status === Loader.Ready

                Layout.fillHeight: true
                containmentMask: Item {
                    parent: virtualKeyboardButton
                    anchors.fill: parent
                    anchors.leftMargin: -footer.anchors.margins
                    anchors.bottomMargin: -footer.anchors.margins
                }
            }

            KeyboardButton {
                id: keyboardButton

                font.pointSize: config.fontSize

                onKeyboardLayoutChanged: {
                    // Otherwise the password field loses focus and virtual keyboard
                    // keystrokes get eaten
                    userListComponent.mainPasswordBox.forceActiveFocus();
                }

                Layout.fillHeight: true
                containmentMask: Item {
                    parent: keyboardButton
                    anchors.fill: parent
                    anchors.leftMargin: virtualKeyboardButton.visible ? 0 : -footer.anchors.margins
                    anchors.bottomMargin: -footer.anchors.margins
                }
            }

            // SessionButton {
            //     id: sessionButton

            //     font.pointSize: config.fontSize

            //     onSessionChanged: {
            //         // Otherwise the password field loses focus and virtual keyboard
            //         // keystrokes get eaten
            //         userListComponent.mainPasswordBox.forceActiveFocus();
            //     }

            //     Layout.fillHeight: true
            //     containmentMask: Item {
            //         parent: sessionButton
            //         anchors.fill: parent
            //         anchors.leftMargin: virtualKeyboardButton.visible || keyboardButton.visible
            //             ? 0 : -footer.anchors.margins
            //         anchors.bottomMargin: -footer.anchors.margins
            //     }
            // }

            Item {
                Layout.fillWidth: true
            }

            // Battery {
            //     fontSize: config.fontSize
            // }
            Row {
                id: controlPanelRow
                spacing: 16
                Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                Layout.rightMargin: 12
                Layout.bottomMargin: 12

                CornerActionButton {
                    id: selectDEButton
                    sourceNormal : "blackbriar-components/artwork/settings.svg"
                    sourceHover  : "blackbriar-components/artwork/settings-hover.svg"
                    sourcePressed: "blackbriar-components/artwork/settings-pressed.svg"
                    callback: function() {                    
                        selectDEMenu.visible = !selectDEMenu.visible
                    }

                    signal sessionChanged()

                    property int currentIndex: sessionModel.currentIndex

                    PlasmaComponents3.Menu {
                        Kirigami.Theme.colorSet: Kirigami.Theme.Window
                        Kirigami.Theme.inherit: false

                        id: selectDEMenu
                        Instantiator {
                            id: instantiator
                            model: sessionModel
                            property int currentIndex: model.lastIndex
                            onObjectAdded: (index, object) => selectDEMenu.insertItem(index, object)
                            onObjectRemoved: (index, object) => selectDEMenu.removeItem(object)
                            delegate: PlasmaComponents3.MenuItem {
                                text: model.name
                                onTriggered: {
                                    selectDEButton.currentIndex = model.index
                                    sessionChanged()
                                }
                            }
                            Component.onCompleted: {
                                selectDEButton.currentIndex = model.lastIndex
                                sessionChanged()
                            }
                        }
                    }
                }

                CornerActionButton {
                    id: rebootButton
                    sourceNormal : "blackbriar-components/artwork/reboot.svg"
                    sourceHover  : "blackbriar-components/artwork/reboot-hover.svg"
                    sourcePressed: "blackbriar-components/artwork/reboot-pressed.svg"
                    callback: function() {
                        sddm.reboot()
                    }
                }

                CornerActionButton {
                    id: shutdownButton
                    sourceNormal : "blackbriar-components/artwork/shutdown.svg"
                    sourceHover  : "blackbriar-components/artwork/shutdown-hover.svg"
                    sourcePressed: "blackbriar-components/artwork/shutdown-pressed.svg"
                    callback: function() {
                        sddm.reboot()
                    }
                }
            }
        }
    }

    onNotificationMessageChanged: {
        if (notificationMessage) {
            notificationResetTimer.start();
        }
    }

    Timer {
        id: notificationResetTimer
        interval: 3000
        onTriggered: notificationMessage = ""
    }
}
