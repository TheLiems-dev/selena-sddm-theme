import QtQuick 2.5

Column {
    id: panel
    z: 3
    spacing: 2 * scaleFactor

    property real scaleFactor: 1.0
    property string timeStr: "00:00"
    property string dateStr: ""

    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: updateClock()
    }

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

    Text {
        text: panel.timeStr
        color: "#ffffff"
        font.pointSize: 48 * panel.scaleFactor
        font.weight: Font.Bold
        font.letterSpacing: 4
        anchors.left: parent.left
    }

    Text {
        text: panel.dateStr
        color: "#cccccc"
        font.pointSize: 14 * panel.scaleFactor
        font.letterSpacing: 1
        anchors.left: parent.left
    }
}
