import QtQuick 2.15
import QtGraphicalEffects 1.12
import QtQuick.Controls 2.15
import QtQuick.Controls 1.4 as Q1
import QtQuick.Controls.Styles 1.4
import SddmComponents 2.0
import "components"

Rectangle {
    id: root
    color: "#000000"
    anchors.fill: parent
    // This custom picture (see theme.conf) is around the top half of the screen
    PicturePanel {
        id: picture
    }
    // Login panel at center of screen. Login field SVGs by phob1an - Nostrum KDE theme
    LoginPanel {
        id: login
    }
    // Bottom right row of icons and buttons. Free icons from Font Awesome

    // Component.onCompleted: {
    //     userField.focus = true
    //     textback1.state = "nay1"  //dunno why both inputs get focused
    // }
}
