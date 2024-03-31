import org.kde.breeze.components

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami
import "blackbriar-components"

SessionManagementScreen {
    id: root
    property Item mainPasswordBox: passwordBox

    property bool showUsernamePrompt: true

    property string lastUserName
    property bool loginScreenUiVisible: false

    //the y position that should be ensured visible when the on screen keyboard is visible
    // property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    // onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + Kirigami.Units.smallSpacing

    property int fontSize: parseInt(config.fontSize)

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    onUserSelected: {
        // Don't startLogin() here, because the signal is connected to the
        // Escape key as well, for which it wouldn't make sense to trigger
        // login.
        focusFirstVisibleFormControl();
    }

    StackView.onActivating: {
        // Controls are not visible yet.
        Qt.callLater(focusFirstVisibleFormControl);
    }

    function focusFirstVisibleFormControl() {
        const nextControl = (userNameInput.visible
            ? userNameInput
            : passwordBox);
        // Using TabFocusReason, so that the loginButton gets the visual highlight.
        nextControl.forceActiveFocus(Qt.TabFocusReason);
    }

    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    function startLogin() {
        const username = userNameInput.text
        const password = passwordBox.text

        footer.enabled = false
        mainStack.enabled = false
        userListComponent.userList.opacity = 0.5

        // This is partly because it looks nicer, but more importantly it
        // works round a Qt bug that can trigger if the app is closed with a
        // TextField focused.
        //
        // See https://bugreports.qt.io/browse/QTBUG-55460
        // loginButton.forceActiveFocus();
        loginRequest(username, password);
    }

    CustomTextField {
        id: userNameInput
        font.pointSize: fontSize + 1
        Layout.fillWidth: true

        text: lastUserName // selectUser.currentText
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
            }

            // states: [
            //     State {
            //         name: "press"
            //         when: selectUser.down
            //         PropertyChanges {
            //             target: usernameIcon
            //             icon.color: Qt.lighter(root.palette.highlight, 1.1)
            //         }
            //     },
            //     State {
            //         name: "hover"
            //         when: selectUser.hovered
            //         PropertyChanges {
            //             target: usernameIcon
            //             icon.color: Qt.lighter(root.palette.highlight, 1.2)
            //         }
            //     },
            //     State {
            //         name: "focus"
            //         when: selectUser.visualFocus
            //         PropertyChanges {
            //             target: usernameIcon
            //             icon.color: root.palette.highlight
            //         }
            //     }
            // ]

            // transitions: [
            //     Transition {
            //         PropertyAnimation {
            //             properties: "color, border.color, icon.color"
            //             duration: 150
            //         }
            //     }
            // ]

        }

        // TextField {
        //     z: 50
        //     id: username
        //     text: config.ForceLastUser == "true" ? selectUser.currentText : null
        //     font.capitalization: Font.Capitalize
        //     anchors.centerIn: parent
        //     height: root.font.pointSize * 3
        //     width: parent.width
        //     placeholderText: config.TranslateUsernamePlaceholder || "BALLS"
        //     selectByMouse: true
        //     horizontalAlignment: TextInput.AlignHCenter
        //     renderType: Text.QtRendering
        //     background: Rectangle {
        //         color: "transparent"
        //         border.color: root.palette.text
        //         border.width: parent.activeFocus ? 2 : 1
        //         radius: config.RoundCorners || 0
        //     }
        //     Keys.onReturnPressed: loginButton.clicked()
        //     KeyNavigation.down: password
        //     // z: 1

        //     states: [
        //         State {
        //             name: "focused"
        //             when: username.activeFocus
        //             PropertyChanges {
        //                 target: username.background
        //                 border.color: root.palette.highlight
        //             }
        //             PropertyChanges {
        //                 target: username
        //                 color: root.palette.highlight
        //             }
        //         }
        //     ]
        // }

        Keys.onReturnPressed: {
            passwordBox.forceActiveFocus()
        }
    }

    RowLayout {
        Layout.fillWidth: true

        CustomPasswordField {
            id: passwordBox
            font.pointSize: fontSize + 1
            Layout.fillWidth: true

            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
            focus: !showUsernamePrompt || lastUserName

            callback: function() {
                if (root.loginScreenUiVisible) {
                    startLogin();
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

            Connections {
                target: sddm
                function onLoginFailed() {
                    passwordBox.selectAll()
                    passwordBox.forceActiveFocus()
                }
            }
        }
    }
}
