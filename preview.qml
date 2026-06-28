import QtQuick
import QtMultimedia

Rectangle {
    width: 1280
    height: 720
    color: "#000000"

    property real scaleFactor: Math.min(width / 1920, height / 1080)
    property bool showLogin: false
    property bool capsLockOn: false
    property bool advExpanded: false
    property string weatherStr: ""
    property string userName: "hieudubai"
    property int sessionIndex: 0
    property var fakeUsers: [{name: "hieudubai"},{name: "root"},{name: "guest"},{name: "lacrimosa"}]
    property var fakeSessions: [{name: "niri"},{name: "plasma"},{name: "hyprland"}]

    MediaPlayer {
        id: player
        source: "/usr/share/sddm/themes/selena/selena video.mp4"
        videoOutput: video
        audioOutput: AudioOutput {
            volume: 0.0
            muted: true
        }
        loops: MediaPlayer.Infinite
        autoPlay: true
    }

    VideoOutput {
        id: video
        anchors.fill: parent
        fillMode: VideoOutput.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.5
    }

    Column {
        id: infoPanel
        anchors { top: parent.top; left: parent.left; topMargin: 32 * scaleFactor; leftMargin: 44 * scaleFactor }
        z: 3; spacing: 2 * scaleFactor

        property string timeStr: "00:00"
        property string dateStr: ""

        Timer { interval: 1000; running: true; repeat: true; onTriggered: updateClock() }

        function updateClock() {
            var d = new Date()
            var h = d.getHours().toString().padStart(2, "0")
            var m = d.getMinutes().toString().padStart(2, "0")
            timeStr = h + ":" + m
            var days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            var months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            dateStr = days[d.getDay()] + ", " + d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear()
        }

        Component.onCompleted: updateClock()

        Text { text: infoPanel.timeStr; color: "#ffffff"; font.pointSize: 48 * scaleFactor; font.weight: Font.Bold; font.letterSpacing: 4; anchors.left: parent.left }
        Text { text: infoPanel.dateStr; color: "#cccccc"; font.pointSize: 14 * scaleFactor; font.letterSpacing: 1; anchors.left: parent.left }
    }

    // Bottom: PGR logo + password field
    Column {
        id: bottomGroup
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; bottomMargin: 60 * scaleFactor }
        spacing: 12 * scaleFactor; z: 3

        Image {
            id: pgrLogo
            source: "/usr/share/sddm/themes/selena/logo pgr.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: 600 * scaleFactor; height: 400 * scaleFactor; fillMode: Image.PreserveAspectFit
            opacity: showLogin ? 0.6 : 1.0
            Behavior on opacity { NumberAnimation { duration: 300 } }
        }

        Rectangle {
            id: passwordBox
            width: 300 * scaleFactor; height: 44 * scaleFactor; radius: 22 * scaleFactor
            color: "transparent"; border.color: passwordInput.activeFocus ? "#7aa2f7" : "#2a2a4e"; border.width: 1
            visible: showLogin
            anchors.horizontalCenter: parent.horizontalCenter

            TextInput {
                id: passwordInput
                anchors.left: parent.left; anchors.leftMargin: 16 * scaleFactor
                anchors.right: parent.right; anchors.rightMargin: 16 * scaleFactor
                anchors.verticalCenter: parent.verticalCenter
                color: "#ffffff"; font.pointSize: 15 * scaleFactor
                echoMode: showPwItem.showPw ? TextInput.Normal : TextInput.Password; focus: true

                property string placeholder: "Password"
                Text { anchors.verticalCenter: parent.verticalCenter; x: 0; text: parent.placeholder; color: "#666666"; font: parent.font; visible: parent.text === "" && !parent.activeFocus }

                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        if (passwordInput.text === "") {
                            errorText.text = "Enter password"
                        } else {
                            errorText.text = ""
                            showLogin = false
                            passwordInput.text = ""
                        }
                        event.accepted = true
                    }
                    if (event.key === Qt.Key_Escape) {
                        showLogin = false
                        passwordInput.text = ""
                        event.accepted = true
                    }
                    if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z && event.text.length > 0) {
                        var shiftHeld = event.modifiers & Qt.ShiftModifier
                        capsLockOn = event.text === event.text.toUpperCase() && !shiftHeld
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter; spacing: 16 * scaleFactor; visible: showLogin

            Item {
                id: showPwItem
                width: showPwArea.width + 24 * scaleFactor; height: 24 * scaleFactor
                property bool showPw: false

                Rectangle {
                    id: showPwBox
                    anchors.verticalCenter: parent.verticalCenter; x: 2 * scaleFactor
                    width: 20 * scaleFactor; height: 20 * scaleFactor; radius: 4 * scaleFactor
                    color: parent.showPw ? "#7aa2f7" : "transparent"
                    border.color: "#565f89"; border.width: 1
                    Text { anchors.centerIn: parent; text: "✓"; color: parent.showPw ? "#ffffff" : "transparent"; font.pointSize: 12; font.bold: true }
                }

                Text {
                    id: showPwArea
                    anchors.left: showPwBox.right; anchors.leftMargin: 6 * scaleFactor
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Show password"; color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
                }

                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.showPw = !parent.showPw }
            }

            Text {
                text: "⇪ Caps Lock"; color: "#e0af68"; font.pointSize: 12 * scaleFactor; font.bold: true
                anchors.verticalCenter: parent.verticalCenter
                visible: capsLockOn && passwordInput.activeFocus
            }
        }

        Text {
            id: errorText
            text: ""; color: "#f7768e"; font.pointSize: 12 * scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter; visible: text !== ""
        }
    }

    SequentialAnimation {
        id: shakeAnim
        loops: 3
        NumberAnimation { target: passwordBox; property: "anchors.horizontalCenterOffset"; from: -8 * scaleFactor; to: 8 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordBox; property: "anchors.horizontalCenterOffset"; from: 8 * scaleFactor; to: -6 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordBox; property: "anchors.horizontalCenterOffset"; from: -6 * scaleFactor; to: 4 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordBox; property: "anchors.horizontalCenterOffset"; from: 4 * scaleFactor; to: -2 * scaleFactor; duration: 50 }
        NumberAnimation { target: passwordBox; property: "anchors.horizontalCenterOffset"; from: -2 * scaleFactor; to: 0; duration: 50 }
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
        enabled: !showLogin && !advExpanded
        onClicked: { showLogin = true; passwordInput.forceActiveFocus() }
    }

    // Top-right action buttons
    Column {
        anchors { top: parent.top; right: parent.right; topMargin: 10; rightMargin: 10 }
        spacing: 4
        z: 10

        Text {
            anchors.right: parent.right
            text: weatherStr
            color: "#a9b1d6"; font.pointSize: 10 * scaleFactor
            visible: weatherStr !== ""
        }

        // Switch account — click cycles to next user
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
                onClicked: {
                    var count = fakeUsers.length
                    if (count > 0) {
                        var idx = 0
                        for (var i = 0; i < count; i++) {
                            if (fakeUsers[i].name === userName) {
                                idx = (i + 1) % count
                                break
                            }
                        }
                        userName = fakeUsers[idx].name
                        console.log("Selected user:", userName)
                    }
                }
            }
        }

        // Session — click cycles to next session
        Rectangle {
            id: sessionBtn
            width: 150 * scaleFactor; height: 32 * scaleFactor; radius: 4
            color: "#1a1b26"; border.color: "#565f89"; border.width: 1
            opacity: 0.9

            Row {
                anchors.centerIn: parent
                spacing: 6 * scaleFactor
                Text {
                    text: sessionName ? "☰" : ""
                    color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
                    visible: sessionName
                }
                Text {
                    text: sessionName || "Session"
                    color: "#a9b1d6"; font.pointSize: 12 * scaleFactor
                }
            }

            MouseArea {
                anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                onClicked: {
                    var count = fakeSessions.length
                    if (count > 0) {
                        var idx = 0
                        for (var i = 0; i < count; i++) {
                            if (fakeSessions[i].name === sessionName) {
                                idx = (i + 1) % count
                                break
                            }
                        }
                        sessionName = fakeSessions[idx].name
                        sessionIndex = idx
                        console.log("Selected session:", sessionName)
                    }
                }
            }
        }

        // Advanced — pill + dropdown (Tracen Ondo style)
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
                Text {
                    anchors { right: parent.right; rightMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                    text: ""; color: "#a9b1d6"; font.pointSize: 8 * scaleFactor
                }
                MouseArea {
                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                    onClicked: advExpanded = !advExpanded
                }
            }

            Rectangle {
                width: 150 * scaleFactor
                height: advExpanded ? 90 * scaleFactor : 0
                clip: true
                radius: 4; color: "#1a1b26"; border.color: "#565f89"; border.width: 1
                Behavior on height { NumberAnimation { duration: 150; easing.type: Easing.OutExpo } }

                Column {
                    id: advDropList
                    anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: 4 * scaleFactor }
                    spacing: 2 * scaleFactor

                    Rectangle {
                        width: parent.width
                        height: 26 * scaleFactor
                        color: advHover1.containsMouse ? "#3b4261" : "transparent"; radius: 3
                        Text {
                            anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                            text: "Suspend"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                        }
                        MouseArea {
                            id: advHover1
                            anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            enabled: advExpanded
                            onClicked: { advExpanded = false; console.log("suspend") }
                        }
                    }
                    Rectangle {
                        width: parent.width
                        height: 26 * scaleFactor
                        color: advHover2.containsMouse ? "#3b4261" : "transparent"; radius: 3
                        Text {
                            anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                            text: "Reboot"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                        }
                        MouseArea {
                            id: advHover2
                            anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            enabled: advExpanded
                            onClicked: { advExpanded = false; console.log("reboot") }
                        }
                    }
                    Rectangle {
                        width: parent.width
                        height: 26 * scaleFactor
                        color: advHover3.containsMouse ? "#3b4261" : "transparent"; radius: 3
                        Text {
                            anchors { left: parent.left; leftMargin: 10 * scaleFactor; verticalCenter: parent.verticalCenter }
                            text: "Shutdown"; color: "#a9b1d6"; font.pointSize: 11 * scaleFactor
                        }
                        MouseArea {
                            id: advHover3
                            anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            enabled: advExpanded
                            onClicked: { advExpanded = false; console.log("shutdown") }
                        }
                    }
                }
            }
        }
    }

    function weatherDesc(code, temp, aqi) {
        var icon = "☀"
        if (code <= 1) icon = "☀"
        else if (code <= 3) icon = "☁"
        else if (code <= 48) icon = "🌫"
        else if (code <= 77) icon = "❄"
        else if (code <= 86) icon = "🌦"
        else if (code <= 99) icon = "⛈"

        var aqiLabel = ""
        if (aqi <= 20) aqiLabel = "Good"
        else if (aqi <= 40) aqiLabel = "Fair"
        else if (aqi <= 60) aqiLabel = "Moderate"
        else if (aqi <= 80) aqiLabel = "Poor"
        else if (aqi <= 100) aqiLabel = "Very Poor"
        else aqiLabel = "Extreme"

        return icon + " " + temp + "°C  AQI " + aqi + " (" + aqiLabel + ")"
    }

    function fetchWeather() {
        var locReq = new XMLHttpRequest()
        locReq.onreadystatechange = function() {
            if (locReq.readyState === XMLHttpRequest.DONE && locReq.status === 200) {
                try {
                    var loc = JSON.parse(locReq.responseText)
                    var lat = loc.lat, lon = loc.lon
                    var wxReq = new XMLHttpRequest()
                    wxReq.onreadystatechange = function() {
                        if (wxReq.readyState === XMLHttpRequest.DONE && wxReq.status === 200) {
                            try {
                                var wxd = JSON.parse(wxReq.responseText)
                                var temp = Math.round(wxd.current.temperature_2m)
                                var code = wxd.current.weather_code
                                var aqiReq = new XMLHttpRequest()
                                aqiReq.onreadystatechange = function() {
                                    if (aqiReq.readyState === XMLHttpRequest.DONE && aqiReq.status === 200) {
                                        try {
                                            var aqid = JSON.parse(aqiReq.responseText)
                                            weatherStr = weatherDesc(code, temp, aqid.current.european_aqi)
                                        } catch(e) { weatherStr = weatherDesc(code, temp, 0) }
                                    }
                                }
                                aqiReq.open("GET", "https://air-quality-api.open-meteo.com/v1/air-quality?latitude=" + lat + "&longitude=" + lon + "&current=european_aqi")
                                aqiReq.send()
                            } catch(e) {}
                        }
                    }
                    wxReq.open("GET", "https://api.open-meteo.com/v1/forecast?latitude=" + lat + "&longitude=" + lon + "&current=temperature_2m,weather_code&timezone=auto")
                    wxReq.send()
                } catch(e) {}
            }
        }
        locReq.open("GET", "http://ip-api.com/json/")
        locReq.send()
    }

    Component.onCompleted: fetchWeather()
}
