import QtQml 2.15
import QtQuick 2.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.workspace.components 2.0 as PW

import org.kde.plasma.private.sessions 2.0
import "../components"
import "../components/animation"

Image {
    id: root
    
    property string sourceNormal: "../components/artwork/shutdown.svg" // Defaults.
    property string sourceHover: "../components/artwork/shutdown-hover.svg"
    property string sourcePressed: "../components/artwork/shutdown-pressed.svg"

    property var callback: function () {
        // root.source = "../components/artwork/reboot.svg" // For testing
    }

    activeFocusOnTab: true
    source: activeFocus ? sourceHover : sourceNormal
    height: 24
    width: 24

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.source = sourceHover
        onExited: root.source = sourceNormal
        onPressed: root.source = sourcePressed
        onReleased: {
            root.source = mouseArea.containsMouse ? sourceHover : sourceNormal;
            if (mouseArea.containsMouse) {
                root.callback()
            }
        }
    }
    Keys.onPressed: {
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Enter) {
            root.callback();
        }
    }
}