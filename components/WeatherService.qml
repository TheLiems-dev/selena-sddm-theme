import QtQuick 2.5

QtObject {
    id: w
    property string weatherStr: ""

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

    function fetch() {
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
                                            w.weatherStr = w.weatherDesc(code, temp, aqid.current.european_aqi)
                                        } catch(e) { w.weatherStr = w.weatherDesc(code, temp, 0) }
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
}
