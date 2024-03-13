import QtQuick 2.15
import QtQuick.Layouts 1.15

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasma5support 2.0 as P5Support

RowLayout {
    PlasmaComponents3.Label {
        id: leftLabel
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "yyyy-MM-dd")
        font.pointSize: 12
    }
    PlasmaComponents3.Label {
        id: bottomLabel
        text: Qt.formatDateTime(timeSource.data["Local"]["DateTime"], "HH:mm")
        font.pointSize: 12
    }
    P5Support.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}
