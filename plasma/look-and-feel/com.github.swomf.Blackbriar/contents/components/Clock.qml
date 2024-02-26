/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    state: lockScreenRoot.uiVisible ? "off" : "on"
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    PlasmaComponents3.Label {
        id: topLabel
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "yyyy-MM-dd")
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 48
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: -8 // Reduce space between two label entries
    }
    PlasmaComponents3.Label {
        id: bottomLabel
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "HH:mm")
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 24
        Layout.alignment: Qt.AlignLeft
        Layout.leftMargin: topLabel.x
        Layout.topMargin: -8
    }
    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
    states: [
        State {
            name: "on"
            PropertyChanges {
                target: topLabel
                opacity: 1
            }
            PropertyChanges {
                target: bottomLabel
                opacity: 1
            }
        },
        State {
            name: "off"
            PropertyChanges {
                target: topLabel
                opacity: 0
            }
            PropertyChanges {
                target: bottomLabel
                opacity: 0
            }
        }
    ]
    transitions: [
        Transition {
            from: "off"
            to: "on"
            //Note: can't use animators as they don't play well with parallelanimations
            NumberAnimation {
                targets: [topLabel, bottomLabel]
                property: "opacity"
                duration: PlasmaCore.Units.veryLongDuration
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "on"
            to: "off"
            NumberAnimation {
                targets: [topLabel, bottomLabel]
                property: "opacity"
                duration: PlasmaCore.Units.veryLongDuration
                easing.type: Easing.OutCubic
            }
        }
    ]
}
