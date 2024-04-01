import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "blackbriar-components"

ColumnLayout {
    id: root
    property Item mainPasswordBox: passwordBox

    property bool showUsernamePrompt: true

    property string lastUserName
    property string desiredSession

    property bool loginScreenUiVisible: true

    property var loginFunction: function(username, password) {}
    
    anchors.topMargin: 80
    spacing: 4

    //the y position that should be ensured visible when the on screen keyboard is visible
    // property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    // onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + Kirigami.Units.smallSpacing

    property int fontSize: parseInt(config.fontSize)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    // function focusFirstVisibleFormControl() {
    //     const nextControl = (userNameInput.visible
    //         ? userNameInput
    //         : passwordBox);
    //     // Using TabFocusReason, so that the loginButton gets the visual highlight.
    //     nextControl.forceActiveFocus(Qt.TabFocusReason);
    // }

    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */

    CustomTextField {
        id: userNameInput
        font.pointSize: fontSize + 1
        Layout.fillWidth: true

        text: selectUser.currentText
        visible: showUsernamePrompt
        focus: showUsernamePrompt && !lastUserName //if there's a username prompt it gets focus first, otherwise password does
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")

        // user selection popup box
        // based on sugar-sddm
        // https://github.com/MarianArlt/sddm-sugar-dark/blob/ceb2c455663429be03ba62d9f898c571650ef7fe/Components/Input.qml#L40
        ComboBox {
            id: selectUser

            width: parent.height
            height: parent.height
            anchors.right: parent.right
            z: 4

            model: userModel
            currentIndex: model.lastIndex
            textRole: "name"
            hoverEnabled: true
            onActivated: {
                userNameInput.text = currentText
            }

            delegate: ItemDelegate {
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                contentItem: Text {
                    text: model.name
                    font.pointSize: root.font.pointSize * 0.8
                    color: userNameInput.color
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                highlighted: parent.highlightedIndex === index
                background: Rectangle {
                    color: selectUser.highlightedIndex === index ? "#303030" : "transparent"
                }
            }

            indicator: Image {
                id: usernameIcon
                height: width
                width: userNameInput.font.pointSize * 1.5

                property string sourceNormal: Qt.resolvedUrl("blackbriar-components/artwork/user.svg")
                property string sourceHover: Qt.resolvedUrl("blackbriar-components/artwork/user-hover.svg")
                property string sourcePressed: Qt.resolvedUrl("blackbriar-components/artwork/user-pressed.svg")

                property bool isClicked: false
                property bool isHeld: false // If spacebar or enter isHeld while button is selected

                source: (isClicked || isHeld) ? sourcePressed
                    : (selectUser.activeFocus || mouseArea.containsMouse) ? sourceHover
                    : sourceNormal

                anchors.right: parent.right
                anchors.rightMargin: userNameInput.font.pointSize * 0.6
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onPressed: usernameIcon.isClicked = true
                    onReleased: {
                        usernameIcon.isClicked = false
                        if (mouseArea.containsMouse) {
                            selectUser.popup.visible = true
                        }
                    }
                }
                Keys.onPressed: (event) => {
                    if (usernameIcon.activeFocus && (event.key === Qt.Key_Space || event.key === Qt.Key_Enter)) { // FIXME hitting enter does not work
                        usernameIcon.isHeld = true
                        selectUser.popup.visible = true
                    }
                }
                Keys.onReleased: (event) => {
                    // Unlike a mouse event, when a keyboard key is held, it auto repeats.
                    // We want the event to fire only when the key is manually released.
                    if (usernameIcon.activeFocus && usernameIcon.isHeld && !event.isAutoRepeat && 
                        (event.key === Qt.Key_Space || event.key === Qt.Key_Enter)) { // FIXME hitting enter does not work
                        usernameIcon.isHeld = false
                    }
                }

            }

            background: Rectangle {
                color: "transparent"
                border.color: "transparent"
            }

            popup: Popup {
                x: parent.width + 3
                rightMargin: config.ForceRightToLeft == "true" ? root.padding + 50 / 2 : undefined
                width: 200
                implicitHeight: contentItem.implicitHeight
                padding: 10

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight + 20
                    model: selectUser.popup.visible ? selectUser.delegateModel : null
                    currentIndex: selectUser.highlightedIndex
                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    radius: 5
                    color: userNameInput.background.color
                    border.color: userNameInput.color
                    layer.enabled: true
                    // layer.effect: DropShadow {
                    //     transparentBorder: true
                    //     horizontalOffset: 0
                    //     verticalOffset: 0
                    //     radius: 100
                    //     samples: 201
                    //     cached: true
                    //     color: "#88000000"
                    // }
                }

                enter: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1 }
                }

                // Keys.onReleased: (event) => {
                //     // Unlike a mouse event, when a keyboard key is held, it auto repeats.
                //     // We want the event to fire only when the key is manually released.
                //     if ((selectUser.popup.activeFocus || selectUser.activeFocus) && !event.isAutoRepeat && 
                //         (event.key === Qt.Key_Space || event.key === Qt.Key_Enter)) { // FIXME hitting enter does not work
                //         passwordBox.forceActiveFocus()
                //     }
                // }
            }


        }

        Keys.onReturnPressed: {
            passwordBox.forceActiveFocus()
        }
    }


    CustomPasswordField {
        id: passwordBox
        font.pointSize: fontSize + 1
        Layout.fillWidth: true

        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
        focus: !showUsernamePrompt || lastUserName

        callback: function() {
            if (root.loginScreenUiVisible) {
                sddm.login(userNameInput.text, passwordBox.text, desiredSession)
                passwordBox.disable()
            }
        }

        // Item {
        //     id: usernameField

        //     height: 12 * 4.5
        //     width: parent.width / 2
        //     anchors.right: parent.right

            

        // }

        // visible: root.showUsernamePrompt || userList.currentItem.needsPassword

        Keys.onEscapePressed: {
            mainStack.currentItem.forceActiveFocus();
        }

        //if empty and left or right is pressed change selection in user switch
        //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Left && !text) {
                userList.decrementCurrentIndex();
                event.accepted = true
            }
            if (event.key === Qt.Key_Right && !text) {
                userList.incrementCurrentIndex();
                event.accepted = true
            }
        }

        Component.onCompleted: {
            if (userNameInput.text !== "") {
                passwordBox.forceActiveFocus()
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            // notificationMessage = i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Login Failed")
            // footer.enabled = true
            // rejectPasswordAnimation.start()
            // passwordBox.background.border.color = "#FF0000"
            passwordBox.enable(true)
        }
        function onLoginSucceeded() {
            //note SDDM will kill the greeter at some random point after this
            //there is no certainty any transition will finish, it depends on the time it
            //takes to complete the init
            mainStack.opacity = 0
            footer.opacity = 0
            passwordBox.enable(false)
        }
    }
}
