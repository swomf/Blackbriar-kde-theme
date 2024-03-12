// SPDX-FileCopyrightText: 2019 Carl-Lucien Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later
 
import QtQuick
import QtQuick.Controls as QQC2
import org.kde.plasma.extras as PlasmaExtras
import org.kde.config as KConfig
import org.kde.kirigami as Kirigami
// https://api.kde.org/plasma/libplasma/html/PasswordField_8qml_source.html
 
/**
 * This is a standard password text field.
 *
 * Example usage for the password field component:
 *
 * @code{.qml}
 * import org.kde.plasma.extras as PlasmaExtras
 *
 * PlasmaExtras.PasswordField {
 *     id: passwordField
 *     onAccepted: {
 *         // check if passwordField.text is valid
 *     }
 * }
 * @endcode
 *
 * @since 5.93
 * @inherit org::kde::plasma::extras::ActionTextField
 * @author Carl Schwan <carl@carlschwan.eu>
 */
PlasmaExtras.ActionTextField {
    id: root
 
    /**
     * This property holds whether we show the clear text password.
     *
     * By default, it's false.
     * @since 5.93
     */
    property bool showPassword: false
    // This glitches during tests, but works fine in actual lockscreen installation
    property url passwordHideSource: Qt.resolvedUrl("artwork/password-hide.svg")
    property url passwordShowSource: Qt.resolvedUrl("artwork/password-show.svg")
 
    Shortcut {
        // Let's consider this shortcut a standard, it's also supported at least by su and sudo
        sequence: "Ctrl+Shift+U"
        enabled: root.activeFocus
        onActivated: root.clear();
    }
 
    echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
    placeholderText: i18nd("libplasma6", "Password")
    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText | Qt.ImhSensitiveData
 
    rightActions: Kirigami.Action {
        enabled: KConfig.KAuthorized.authorize("lineedit_reveal_password")
        visible: enabled
        icon.source: root.showPassword ? passwordHideSource : passwordShowSource
        onTriggered: root.showPassword = !root.showPassword
    }
 
    Keys.onPressed: event => {
        if (event.matches(StandardKey.Undo)) {
            // Disable undo action for security reasons
            // See QTBUG-103934
            event.accepted = true
        }
    }
}