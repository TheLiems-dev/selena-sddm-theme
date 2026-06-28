import QtQuick 2.5
import QtMultimedia 5.0
import "components"

Rectangle {
    id: root
    width: 1280
    height: 720
    color: "#000000"

    property real scaleFactor: Math.min(width / 1920, height / 1080)
    property bool showLogin: false
    property bool advExpanded: false
    property string userName: "hieudubai"
    property string sessionName: "niri"
    property var fakeUsers: ["hieudubai", "root", "guest", "lacrimosa"]
    property var fakeSessions: ["niri", "plasma", "hyprland"]

    Video {
        id: video
        source: "background.mp4"
        anchors.fill: parent
        fillMode: 2
        loops: -1
        autoPlay: true
        muted: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"; opacity: 0.5
    }

    InfoPanel {
        id: infoPanel
        anchors {
            top: parent.top; left: parent.left
            topMargin: 32 * scaleFactor; leftMargin: 44 * scaleFactor
        }
        scaleFactor: root.scaleFactor
    }

    Column {
        id: bottomGroup
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom; bottomMargin: 60 * scaleFactor
        }
        spacing: 12 * scaleFactor; z: 3

        Image {
            id: pgrLogo
            source: "logo pgr.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: 600 * scaleFactor; height: 400 * scaleFactor
            fillMode: Image.PreserveAspectFit
            opacity: showLogin ? 0.6 : 1.0
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        PasswordPanel {
            id: passwordPanel
            scaleFactor: root.scaleFactor
            showLogin: root.showLogin

            onLoginRequested: {
                errorText = ""
                if (passwordPanel.passwordInput.text === "") {
                    errorText = "Enter password"
                } else {
                    root.showLogin = false
                    passwordPanel.passwordInput.text = ""
                }
            }
        }
    }

    ActionButtons {
        id: actBtns
        anchors {
            top: parent.top; right: parent.right
            topMargin: 10 * scaleFactor; rightMargin: 10 * scaleFactor
        }
        scaleFactor: root.scaleFactor
        weatherStr: weatherSvc.weatherStr
        userName: root.userName
        sessionName: root.sessionName
        advExpanded: root.advExpanded

        onAdvExpandedChanged: root.advExpanded = actBtns.advExpanded
        onUserSwitchClicked: {
            var idx = fakeUsers.indexOf(root.userName)
            if (idx >= 0) {
                root.userName = fakeUsers[(idx + 1) % fakeUsers.length]
                actBtns.userName = root.userName
            }
        }
        onSessionSwitchClicked: {
            var idx = fakeSessions.indexOf(root.sessionName)
            if (idx >= 0) {
                root.sessionName = fakeSessions[(idx + 1) % fakeSessions.length]
                actBtns.sessionName = root.sessionName
            }
        }
        onSuspendClicked: console.log("suspend")
        onRebootClicked: console.log("reboot")
        onShutdownClicked: console.log("shutdown")
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        enabled: !showLogin && !root.advExpanded
        onClicked: {
            showLogin = true
            passwordPanel.passwordInput.forceActiveFocus()
        }
    }

    WeatherService { id: weatherSvc }

    Component.onCompleted: weatherSvc.fetch()
}
