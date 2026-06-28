import QtQuick 2.5

Column {
    id: panel
    spacing: 12 * scaleFactor
    z: 3

    property real scaleFactor: 1.0
    property bool showLogin: false
    property bool capsLockOn: false
    property string errorText: ""
    property alias passwordInput: input
    property alias shakeTarget: passwordBox
    signal loginRequested

    Rectangle {
        id: passwordBox
        width: 300 * scaleFactor
        height: 44 * scaleFactor
        radius: 22 * scaleFactor
        color: "transparent"
        border.color: input.activeFocus ? "#7aa2f7" : "#2a2a4e"
        border.width: 1
        visible: showLogin
        anchors.horizontalCenter: parent.horizontalCenter

        TextInput {
            id: input
            anchors.left: parent.left
            anchors.leftMargin: 16 * scaleFactor
            anchors.right: parent.right
            anchors.rightMargin: 16 * scaleFactor
            anchors.verticalCenter: parent.verticalCenter
            color: "#ffffff"
            font.pointSize: 15 * scaleFactor
            echoMode: showPwItem.showPw ? TextInput.Normal : TextInput.Password
            focus: true

            property string placeholder: "Password"
            Text {
                anchors.verticalCenter: parent.verticalCenter
                x: 0
                text: parent.placeholder
                color: "#666666"
                font: parent.font
                visible: parent.text === "" && !parent.activeFocus
            }

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    panel.loginRequested()
                    event.accepted = true
                }
                if (event.key === Qt.Key_Escape) {
                    panel.showLogin = false
                    input.text = ""
                    event.accepted = true
                }
                if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z && event.text.length > 0) {
                    var shiftHeld = event.modifiers & Qt.ShiftModifier
                    panel.capsLockOn = event.text === event.text.toUpperCase() && !shiftHeld
                }
            }
        }
    }

    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 16 * scaleFactor
        visible: showLogin

        Item {
            id: showPwItem
            width: showPwArea.width + 24 * scaleFactor
            height: 24 * scaleFactor
            property bool showPw: false

            Rectangle {
                id: showPwBox
                anchors.verticalCenter: parent.verticalCenter
                x: 2 * scaleFactor
                width: 20 * scaleFactor
                height: 20 * scaleFactor
                radius: 4 * scaleFactor
                color: parent.showPw ? "#7aa2f7" : "transparent"
                border.color: "#565f89"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "✓"
                    color: parent.showPw ? "#ffffff" : "transparent"
                    font.pointSize: 12; font.bold: true
                }
            }
            Text {
                id: showPwArea
                anchors.left: showPwBox.right
                anchors.leftMargin: 6 * scaleFactor
                anchors.verticalCenter: parent.verticalCenter
                text: "Show password"
                color: "#a9b1d6"
                font.pointSize: 12 * scaleFactor
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: parent.showPw = !parent.showPw
            }
        }

        Text {
            text: "⇪ Caps Lock"
            color: "#e0af68"
            font.pointSize: 12 * scaleFactor
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            visible: capsLockOn && input.activeFocus
        }
    }

    Text {
        text: panel.errorText
        color: "#f7768e"
        font.pointSize: 12 * scaleFactor
        anchors.horizontalCenter: parent.horizontalCenter
        visible: text !== ""
    }
}
