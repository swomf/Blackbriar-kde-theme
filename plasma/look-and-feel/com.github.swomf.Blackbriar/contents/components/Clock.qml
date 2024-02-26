/*
    SPDX-FileCopyrightText: 2016 David Edmundson <davidedmundson@kde.org>

    SPDX-License-Identifier: LGPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    PlasmaComponents3.Label {
        id: topLabel
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "yyyy-MM-dd")
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 48
        Layout.alignment: Qt.AlignHCenter
    }
    PlasmaComponents3.Label {
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "HH:mm")
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 24
        Layout.alignment: Qt.AlignLeft
        Layout.leftMargin: topLabel.x
    }
    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}
