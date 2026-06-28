import QtQuick
import QtMultimedia
import "./components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    property real scaleFactor: Math.min(width / 1920, height / 1080)
    property bool showLogin: false
    property bool advExpanded: false
    focus: true

    Keys.onEscapePressed: {
        showLogin = false
        passwordPanel.passwordInput.text = ""
    }

    MediaPlayer {
        id: player
        source: "background.mp4"
        volume: 0.0; muted: true
        loops: MediaPlayer.Infinite
        autoPlay: true
    }

    VideoOutput {
        id: video
        source: player
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
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
            onLoginRequested: login()
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
        advExpanded: root.advExpanded

        onAdvExpandedChanged: root.advExpanded = actBtns.advExpanded
        onUserSwitchClicked: {
            if (typeof userHelper !== "undefined" && typeof userHelper.count === "number" && userHelper.count > 0)
                userHelper.currentIndex = (userHelper.currentIndex + 1) % userHelper.count
        }
        onSessionSwitchClicked: {
            if (typeof sessionHelper !== "undefined" && typeof sessionHelper.count === "number" && sessionHelper.count > 0)
                sessionHelper.currentIndex = (sessionHelper.currentIndex + 1) % sessionHelper.count
        }
        onSuspendClicked: sddm.suspend()
        onRebootClicked: sddm.reboot()
        onShutdownClicked: sddm.powerOff()
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

    SequentialAnimation {
        id: shakeAnim
        loops: 3
        NumberAnimation { target: passwordPanel.shakeTarget; property: "anchors.horizontalCenterOffset"; from: -8 * scaleFactor; to: 8 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordPanel.shakeTarget; property: "anchors.horizontalCenterOffset"; from: 8 * scaleFactor; to: -6 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordPanel.shakeTarget; property: "anchors.horizontalCenterOffset"; from: -6 * scaleFactor; to: 4 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordPanel.shakeTarget; property: "anchors.horizontalCenterOffset"; from: 4 * scaleFactor; to: -2 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordPanel.shakeTarget; property: "anchors.horizontalCenterOffset"; from: -2 * scaleFactor; to: 0; duration: 50 }
    }

    ListView {
        id: userHelper
        model: typeof userModel !== "undefined" ? userModel : null
        currentIndex: 0
        opacity: 0; width: 1; height: 1; z: -100; interactive: false
        delegate: Item { property string uName: model.name || "" }
    }

    ListView {
        id: sessionHelper
        model: typeof sessionModel !== "undefined" ? sessionModel : null
        currentIndex: 0
        opacity: 0; width: 1; height: 1; z: -100; interactive: false
        delegate: Item { property string sName: model.name || "" }
    }

    WeatherService { id: weatherSvc }

    Component.onCompleted: {
        if (userHelper.count > 0) userHelper.currentIndex = 0
        if (sessionHelper.count > 0) {
            for (var i = 0; i < sessionHelper.count; i++) {
                if (typeof sessionHelper.itemAtIndex !== "undefined") {
                    var item = sessionHelper.itemAtIndex(i)
                    if (item && item.sName === "niri") {
                        sessionHelper.currentIndex = i; break
                    }
                }
            }
            if (sessionHelper.currentIndex < 0 || sessionHelper.currentIndex >= sessionHelper.count)
                sessionHelper.currentIndex = 0
        }
        weatherSvc.fetch()
    }

    Timer {
        id: bootTimer
        interval: 800
        onTriggered: sddm.login(
            userHelper.currentItem ? userHelper.currentItem.uName : "",
            passwordPanel.passwordInput.text,
            sessionHelper.currentIndex
        )
    }

    function login() {
        if (passwordPanel.passwordInput.text === "") {
            passwordPanel.errorText = "Enter password"
            return
        }
        bootTimer.start()
    }

    Connections {
        target: sddm
        function onLoginSucceeded() { bootTimer.stop() }
        function onLoginFailed() {
            bootTimer.stop()
            passwordPanel.errorText = "Incorrect password"
            shakeAnim.start()
            passwordPanel.passwordInput.forceActiveFocus()
        }
    }
}
