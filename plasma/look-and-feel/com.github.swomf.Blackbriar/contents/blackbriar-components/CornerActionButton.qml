import QtQml 2.15
import QtQuick 2.8
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import "../blackbriar-components"

Image {
    id: root
    
    property string sourceNormal: Qt.resolvedUrl("../blackbriar-components/artwork/shutdown.svg") //Defaults.
    property string sourceHover: Qt.resolvedUrl("../blackbriar-components/artwork/shutdown-hover.svg")
    property string sourcePressed: Qt.resolvedUrl("../blackbriar-components/artwork/shutdown-pressed.svg")
    property bool isClicked: false
    property bool isHeld: false // If spacebar or enter isHeld while button is selected

    property var callback: function () {}

    activeFocusOnTab: true
    source: ((root.activeFocus || mouseArea.containsMouse) && !(isClicked || isHeld)) ? sourceHover 
                : (isClicked || isHeld) ? sourcePressed
                : sourceNormal
    height: 24
    width: 24

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPressed: root.isClicked = true
        onReleased: {
            root.isClicked = false
            if (mouseArea.containsMouse) {
                root.callback()
            }
        }
    }
    onActiveFocusChanged: {
        root.isHeld = false
    }
    Keys.onPressed: (event) => {
        if (root.activeFocus && (event.key === Qt.Key_Space || event.key === Qt.Key_Enter)) { // FIXME hitting enter does not work
            root.isHeld = true
        }
    }
    Keys.onReleased: (event) => {
        // Unlike a mouse event, when a keyboard key is held, it auto repeats.
        // We want the event to fire only when the key is manually released.
        if (root.activeFocus && root.isHeld && !event.isAutoRepeat && 
            (event.key === Qt.Key_Space || event.key === Qt.Key_Enter)) { // FIXME hitting enter does not work
            root.isHeld = false
            root.callback();
        }
    }
}