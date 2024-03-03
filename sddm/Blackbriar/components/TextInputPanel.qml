import "."
import QtGraphicalEffects 1.12
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0

TextField {
    id: passwordField

    z: 0
    anchors.horizontalCenter: parent.horizontalCenter
    width: 280
    height: 30
    font.family: "Noto Sans"
    font.pixelSize: 15
    color: "white"
    onActiveFocusChanged: {
        if (activeFocus)
            bg.state = "highlighted";
        else
            bg.state = "unhighlighted";
    }

    Image {
        z: -2
        source: "images/input.svg"
        anchors.fill: parent
    }

    background: Image {
        id: bg

        source: "images/inputhi.svg"
        z: -1
        opacity: 0
        states: [
            State {
                name: "highlighted"

                PropertyChanges {
                    target: bg
                    source: "images/inputhi.svg"
                }

            },
            State {
                name: "unhighlighted"

                PropertyChanges {
                    target: bg
                    source: "images/input.svg"
                }

            }
        ]
        transitions: [
            Transition {
                to: "highlighted"

                NumberAnimation {
                    target: bg
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 200
                }

            },
            Transition {
                to: "unhighlighted"

                NumberAnimation {
                    target: bg
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                }

            }
        ]
    }

}
