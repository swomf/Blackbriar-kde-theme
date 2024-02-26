/*
    SPDX-FileCopyrightText: 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.plasma.private.sessions 2.0
import "../components"

Item {
    id: wallpaperFader
    property Item clock
    property Item mainStack
    property Item footer
    state: lockScreenRoot.uiVisible ? "on" : "off"
    readonly property bool lightColorScheme: Math.max(PlasmaCore.ColorScope.backgroundColor.r, PlasmaCore.ColorScope.backgroundColor.g, PlasmaCore.ColorScope.backgroundColor.b) > 0.5

    property bool alwaysShowClock: typeof config === "undefined" || typeof config.alwaysShowClock === "undefined" || config.alwaysShowClock === true

    states: [
        State {
            name: "on"
            PropertyChanges {
                target: mainStack
                opacity: 1
            }
            PropertyChanges {
                target: footer
                opacity: 1
            }
            PropertyChanges {
                target: clock.shadow
                opacity: 0
            }
            PropertyChanges {
                target: clock
                opacity: 1
            }
        },
        State {
            name: "off"
            PropertyChanges {
                target: mainStack
                opacity: 0
            }
            PropertyChanges {
                target: footer
                opacity: 0
            }
            PropertyChanges {
                target: clock.shadow
                opacity: wallpaperFader.alwaysShowClock ? 1 : 0
            }
            PropertyChanges {
                target: clock
                opacity: wallpaperFader.alwaysShowClock ? 1 : 0
            }
        }
    ]
    transitions: [
        Transition {
            from: "off"
            to: "on"
            //Note: can't use animators as they don't play well with parallelanimations
            NumberAnimation {
                targets: [mainStack, footer, clock]
                property: "opacity"
                duration: PlasmaCore.Units.veryLongDuration
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: "on"
            to: "off"
            NumberAnimation {
                targets: [mainStack, footer, clock]
                property: "opacity"
                duration: PlasmaCore.Units.veryLongDuration
                easing.type: Easing.InOutQuad
            }
        }
    ]
}
