import "."
import QtGraphicalEffects 1.12
import QtQml.Models 2.12
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

Item {
    anchors.fill: parent
    property var sessionIndex: sessionList.currentIndex

    Image {
        id: shutdownButton

        source: "images/shutdown.svg"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        height: 24
        width: 24

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.source = "images/shutdownhover.svg";
            }
            onExited: {
                parent.source = "images/shutdown.svg";
            }
            onPressed: {
                parent.source = "images/shutdownpressed.svg";
                sddm.powerOff();
            }
            onReleased: {
                parent.source = "images/shutdown.svg";
            }
        }

    }

    Image {
        id: rebootButton

        source: "images/reboot.svg"
        anchors.right: shutdownButton.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        height: 24
        width: 24

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.source = "images/reboothover.svg";
            }
            onExited: {
                parent.source = "images/reboot.svg";
            }
            onPressed: {
                parent.source = "images/rebootpressed.svg";
                sddm.reboot();
            }
            onReleased: {
                parent.source = "images/reboot.svg";
            }
        }

    }

    Image {
        id: settingsButton

        source: "images/settings.svg"
        anchors.right: rebootButton.left
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16
        height: 24
        width: 24

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                parent.source = "images/settingshover.svg";
                sessionPopup.open();
            }
            onExited: {
                parent.source = "images/settings.svg";
            }
            onPressed: {
                parent.source = "images/settingspressed.svg";
            }
            onReleased: {
                parent.source = "images/settings.svg";
                sessionPopup.close();
            }
        }

    }

    DelegateModel {
        id: sessionWrapper

        model: sessionModel

        delegate: ItemDelegate {
            id: sessionEntry

            height: settingsButton.height
            width: parent.width
            highlighted: sessionList.currentIndex == index
            states: [
                State {
                    name: "hovered"
                    when: sessionEntry.hovered

                    PropertyChanges {
                        target: sessionEntryBackground
                        color: "#202020"
                    }

                }
            ]

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    sessionList.currentIndex = index;
                    sessionPopup.close();
                }
            }

            contentItem: Text {
                renderType: Text.NativeRendering
                font.family: "Noto Sans"
                font.pointSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: "#bbbbbb"
                text: name
            }

            background: Rectangle {
                id: sessionEntryBackground

                color: "#161616"
                radius: 3
            }

            transitions: Transition {
                PropertyAnimation {
                    property: "color"
                    duration: 300
                }

            }

        }

    }

    Popup {
        id: sessionPopup

        width: 240
        x: settingsButton.x - 245
        y: -contentHeight + settingsButton.y + 14
        height: (contentHeight + padding * 2)
        padding: 10

        background: Rectangle {
            radius: 1
            color: "transparent"
        }

        contentItem: ListView {
            id: sessionList

            implicitHeight: contentHeight
            spacing: 8
            model: sessionWrapper
            currentIndex: sessionModel.lastIndex
            clip: true
            highlight: Rectangle {
                color: "#fe7551"
                z: 2
                opacity: .1
                radius: 5
            }
        }

        enter: Transition {
            ParallelAnimation {
                NumberAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 400
                    easing.type: Easing.OutExpo
                }

            }

        }

        exit: Transition {
            NumberAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
                easing.type: Easing.OutExpo
            }

        }

    }

}
