import QtQuick

Column {
    id: column
    z: 10
    spacing: 4 * scaleFactor

    property real scaleFactor: 1.0
    property string weatherStr: ""
    property string userName: ""
    property string sessionName: ""
    property bool advExpanded: false
    signal userSwitchClicked
    signal sessionSwitchClicked
    signal suspendClicked
    signal rebootClicked
    signal shutdownClicked

    Text {
        anchors.right: parent.right
        text: weatherStr
        color: "#a9b1d6"
        font.pointSize: 10 * scaleFactor
        visible: weatherStr !== ""
    }

    Rectangle {
        id: switchBtn
        width: 150 * scaleFactor; height: 32 * scaleFactor; radius: 4
        color: "#1a1b26"; border.color: "#565f89"; border.width: 1
        opacity: 0.9

        Row {
            anchors.centerIn: parent
            spacing: 6 * scaleFactor
            Text {
                text: "✏"
                color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
                transform: Rotation { angle: 45 }
                visible: userName
            }
            Text {
                text: userName || "Switch account"
                color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
            }
        }
        MouseArea {
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
            onClicked: userSwitchClicked()
        }
    }

    Rectangle {
        id: sessionBtn
        width: 150 * scaleFactor; height: 32 * scaleFactor; radius: 4
        color: "#1a1b26"; border.color: "#565f89"; border.width: 1
        opacity: 0.9

        Row {
            anchors.centerIn: parent
            spacing: 6 * scaleFactor
            Text {
                text: sessionName ? "☰ " + sessionName : "Session"
                color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
            }
        }
        MouseArea {
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
            onClicked: sessionSwitchClicked()
        }
    }

    Column {
        id: advCol
        z: 10
        Rectangle {
            id: advPill
            width: 150 * scaleFactor; height: 32 * scaleFactor; radius: 4
            color: "#1a1b26"; border.color: "#565f89"; border.width: 1
            opacity: 0.9
            Text {
                anchors.centerIn: parent
                text: "⚙  Advanced"; color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
            }
            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: column.advExpanded = !column.advExpanded
            }
        }

        Rectangle {
            width: 150 * scaleFactor
            height: column.advExpanded ? 90 * scaleFactor : 0
            clip: true
            radius: 4; color: "#1a1b26"; border.color: "#565f89"; border.width: 1
            Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutExpo } }

            Column {
                anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 4 * scaleFactor }
                spacing: 2 * scaleFactor

                Rectangle {
                    width: parent.width
                    height: 26 * scaleFactor
                    color: h1.containsMouse ? "#3b4261" : "transparent"; radius: 3
                    Text {
                        anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                        text: "☾  Suspend"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                    }
                    MouseArea {
                        id: h1
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        enabled: column.advExpanded
                        onClicked: { column.advExpanded = false; suspendClicked() }
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 26 * scaleFactor
                    color: h2.containsMouse ? "#3b4261" : "transparent"; radius: 3
                    Text {
                        anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                        text: "↻  Reboot"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                    }
                    MouseArea {
                        id: h2
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        enabled: column.advExpanded
                        onClicked: { column.advExpanded = false; rebootClicked() }
                    }
                }
                Rectangle {
                    width: parent.width
                    height: 26 * scaleFactor
                    color: h3.containsMouse ? "#3b4261" : "transparent"; radius: 3
                    Text {
                        anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                        text: "⏻  Shutdown"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                    }
                    MouseArea {
                        id: h3
                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        enabled: column.advExpanded
                        onClicked: { column.advExpanded = false; shutdownClicked() }
                    }
                }
            }
        }
    }
}
