// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Layouts
import QtMultimedia
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import "../code/colorUtils.js" as ColorUtils

PlasmoidItem {
    id: root

    preferredRepresentation: fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: i18nc("Snooze the currently ringing alarm", "Snooze alarm (%1 min)", Plasmoid.configuration.snoozeMinutes)
            icon.name: "media-playback-pause"
            visible: alarmActive
            onTriggered: snoozeAlarm()
        }
    ]

    ClockFonts {
        id: clockFonts
        family: Plasmoid.configuration.fontFamily
    }

    readonly property string activeFontFamily: clockFonts.name
    readonly property bool activeFontBold: Plasmoid.configuration.fontStyle === "Bold" || Plasmoid.configuration.fontStyle === "Bold Italic"
    readonly property bool activeFontItalic: Plasmoid.configuration.fontStyle === "Italic" || Plasmoid.configuration.fontStyle === "Bold Italic"
    readonly property real fontVerticalCorrection: Plasmoid.configuration.fontFamily === "DotMatrix" ? Math.round(digitFontSize * 0.10) : 0
    readonly property real vFontVerticalCorrection: Plasmoid.configuration.fontFamily === "DotMatrix" ? Math.round(vGroupFontSize * 0.10) : 0

    readonly property bool horizontalPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool verticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool planarMode: !horizontalPanel && !verticalPanel
    readonly property real referenceHeight: 120
    readonly property int naturalWidthEstimate: {
        var digitCount = Plasmoid.configuration.showSeconds ? 6 : 4
        var colonCount = Plasmoid.configuration.showSeconds ? 2 : 1
        var estimate = digitCount * 18 + colonCount * 9 + (digitCount + colonCount - 1) + 24
        if (!Plasmoid.configuration.use24HourFormat) {
            estimate += 20
        }
        return estimate
    }
    readonly property real sizeScale: {
        var baseScale
        if (horizontalPanel && Plasmoid.height > 0) {
            baseScale = Math.max(0.35, Math.min(1.0, Plasmoid.height / referenceHeight))
        } else if (planarMode) {
            var widthScale = Plasmoid.width > 0 ? Plasmoid.width / naturalWidthEstimate : 1.0
            var heightScale = Plasmoid.height > 0 ? Plasmoid.height / referenceHeight : 1.0
            var minScale = Math.min(widthScale, heightScale)
            baseScale = Math.max(0.5, Math.min(8.0, minScale * 2.5))
        } else if (verticalPanel) {
            baseScale = 1.0
        } else {
            baseScale = 1.0
        }
        return baseScale * Plasmoid.configuration.fontScale
    }
    readonly property real vReferenceThickness: 40
    readonly property real vSizeScale: {
        if (verticalPanel && Plasmoid.width > 0) {
            return Math.max(0.4, Math.min(1.6, Plasmoid.width / vReferenceThickness)) * Plasmoid.configuration.fontScale
        } else if (planarMode) {
            return Math.max(0.4, Math.min(1.6, Math.min(Plasmoid.width, Plasmoid.height) / vReferenceThickness)) * Plasmoid.configuration.fontScale
        }
        return Plasmoid.configuration.fontScale
    }
    readonly property int vGroupFontSize: Math.max(8, Math.round(15 * vSizeScale))
    readonly property int vDotSize: Math.max(1, Math.round(2 * vSizeScale))
    readonly property real condensedFactor: Plasmoid.configuration.layoutCondensed ? 0.82 : 1.0
    readonly property real layoutScale: sizeScale * condensedFactor

    readonly property real containerRadius: 16
    readonly property real containerBorderWidth: 2
    readonly property int planarMinimumWidth: 20
    readonly property int planarMinimumHeight: 15
    readonly property real vCharBoxWidthRatio: 0.7
    readonly property real colonHorizontalNudge: Math.round(digitFontSize * 0.15 * condensedFactor)
    readonly property int containerPadding: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(4, Math.round(Plasmoid.height * 0.1))
        }
        return Math.max(6, Math.round(24 * sizeScale))
    }
    readonly property int digitFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(4, Math.round(Plasmoid.height * 0.4 * Plasmoid.configuration.fontScale))
        }
        return Math.max(6, Math.round((Plasmoid.configuration.showDate ? 11 : 15) * sizeScale))
    }
    readonly property int ampmFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(3, Math.round(Plasmoid.height * 0.3 * Plasmoid.configuration.fontScale))
        }
        return Math.max(5, Math.round((Plasmoid.configuration.showDate ? 8 : 12) * sizeScale))
    }
    readonly property int dateFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(3, Math.round(Plasmoid.height * 0.2 * Plasmoid.configuration.fontScale))
        }
        return Math.max(5, Math.round(8 * sizeScale))
    }
    readonly property int dotSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(1, Math.round(Plasmoid.height * 0.0375 * Plasmoid.configuration.fontScale))
        }
        return Math.max(1, Math.round(2 * sizeScale))
    }
    

    readonly property var activeStyle: ColorUtils.getStyleComponents(Plasmoid.configuration.clockStyle, Plasmoid.configuration.customColor)
    readonly property color activeBgColor: Qt.rgba(activeStyle.bg[0], activeStyle.bg[1], activeStyle.bg[2], activeStyle.bg[3])
    readonly property color activeTextColor: Qt.rgba(activeStyle.text[0], activeStyle.text[1], activeStyle.text[2], activeStyle.text[3])
    readonly property color activeShadowColor: Qt.rgba(activeStyle.shadow[0], activeStyle.shadow[1], activeStyle.shadow[2], activeStyle.shadow[3])
    readonly property color activeBorderColor: Qt.rgba(activeStyle.border[0], activeStyle.border[1], activeStyle.border[2], activeStyle.border[3])
    readonly property int alarmHour24: {
        if (Plasmoid.configuration.use24HourFormat) {
            return Plasmoid.configuration.alarmHour
        }
        var hour12 = Plasmoid.configuration.alarmHour % 12
        return Plasmoid.configuration.alarmAmPm === "PM" ? hour12 + 12 : hour12
    }

    property string currentTimeStr: "88:88:88"
    property string currentDateStr: "88/88/88"
    property string ampmIndicator: ""
    property bool dotState: true
    property real flickerOpacity: 1.0
    property real minuteFlickerOpacity: 1.0
    property real lampTestOpacity: Plasmoid.configuration.startupTest ? 1.0 : 0.0
    property int lastMinute: -1
    property var timeDigits: ["8", "8", ":", "8", "8", ":", "8", "8"]
    property bool alarmActive: false
    property bool alarmBlinkState: true
    property int alarmSecondsRemaining: 0
    property int alarmTriggeredMinute: -1
    property date alarmStartTime: new Date(0)
    property bool snoozeActive: false
    property date snoozeUntil: new Date(0)

    MediaPlayer {
        id: alarmPlayer
        source: Qt.resolvedUrl("../assets/alarm.ogg")
        audioOutput: AudioOutput {
            volume: 1.0
        }
        loops: MediaPlayer.Infinite
    }

    AlarmDialog {
        visible: alarmActive
        visualParent: root
        location: Plasmoid.location
        backgroundColor: activeBgColor
        borderColor: activeBorderColor
        textColor: activeTextColor
        fontFamily: activeFontFamily
        snoozeMinutes: Plasmoid.configuration.snoozeMinutes
        onStopRequested: stopAlarm()
        onSnoozeRequested: snoozeAlarm()
    }

    Timer {
        id: clockTimer
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            updateClock()
            checkAlarm()
        }
    }

    Timer {
        id: alarmBlinkTimer
        interval: 500
        repeat: true
        running: alarmActive
        onTriggered: {
            alarmBlinkState = !alarmBlinkState
        }
    }

    Timer {
        id: alarmDurationTimer
        interval: 100
        repeat: true
        running: alarmActive
        onTriggered: {
            var now = new Date()
            var elapsed = (now.getTime() - alarmStartTime.getTime()) / 1000
            alarmSecondsRemaining = Math.max(0, 60 - Math.floor(elapsed))
            if (elapsed >= 60) {
                stopAlarm()
            }
        }
    }

    Timer {
        id: blinkTimer
        interval: 500
        repeat: true
        running: Plasmoid.configuration.blinkDots
        onTriggered: {
            dotState = !dotState
        }
    }

    Timer {
        id: flickerTimer
        interval: 120
        repeat: true
        running: Plasmoid.configuration.flickerEffect
        onTriggered: {
            var r = Math.random()
            if (r < 0.1) {
                flickerOpacity = 0.55 + Math.random() * 0.2
            } else if (r < 0.3) {
                flickerOpacity = 0.85 + Math.random() * 0.1
            } else {
                flickerOpacity = 0.97 + Math.random() * 0.03
            }
            interval = 60 + Math.random() * 150
        }
        onRunningChanged: {
            if (!running) {
                flickerOpacity = 1.0
            }
        }
    }

    SequentialAnimation {
        id: minuteFlickerAnimation
        NumberAnimation { target: root; property: "minuteFlickerOpacity"; to: 0.35; duration: 60 }
        NumberAnimation { target: root; property: "minuteFlickerOpacity"; to: 1.0; duration: 140 }
    }

    SequentialAnimation {
        id: lampTestAnimation
        running: Plasmoid.configuration.startupTest
        PauseAnimation { duration: 1800 }
        NumberAnimation { target: root; property: "lampTestOpacity"; to: 0.0; duration: 700; easing.type: Easing.InQuad }
    }
    
    function updateClock() {
        var now = new Date()
        var hours = now.getHours()
        var minutes = now.getMinutes()
        var seconds = now.getSeconds()
        var day = now.getDate()
        var month = now.getMonth() + 1
        var year = now.getFullYear().toString().slice(-2)

        if (!Plasmoid.configuration.use24HourFormat) {
            ampmIndicator = hours >= 12 ? "PM" : "AM"
            hours = hours % 12
            if (hours === 0) {
                hours = 12
            }
        } else {
            ampmIndicator = ""
        }

        var h1 = Math.floor(hours / 10)
        var h2 = hours % 10
        var m1 = Math.floor(minutes / 10)
        var m2 = minutes % 10
        var s1 = Math.floor(seconds / 10)
        var s2 = seconds % 10
        var d1 = Math.floor(day / 10)
        var d2 = day % 10
        var mo1 = Math.floor(month / 10)
        var mo2 = month % 10

        if (Plasmoid.configuration.showSeconds) {
            timeDigits = [h1.toString(), h2.toString(), ":", m1.toString(), m2.toString(), ":", s1.toString(), s2.toString()]
        } else {
            timeDigits = [h1.toString(), h2.toString(), ":", m1.toString(), m2.toString()]
        }

        currentDateStr = d1.toString() + d2.toString() + "/" + mo1.toString() + mo2.toString() + "/" + year
        currentTimeStr = timeDigits.join("")

        if (Plasmoid.configuration.minuteFlicker && lastMinute !== -1 && minutes !== lastMinute) {
            minuteFlickerAnimation.restart()
        }
        lastMinute = minutes
    }

    function checkAlarm() {
        if (!Plasmoid.configuration.alarmEnabled) {
            snoozeActive = false
            return
        }

        var now = new Date()

        if (snoozeActive) {
            if (now.getTime() >= snoozeUntil.getTime()) {
                snoozeActive = false
                startAlarm()
            }
            return
        }

        var currentHour = now.getHours()
        var currentMinute = now.getMinutes()

        if (currentMinute !== alarmTriggeredMinute) {
            alarmTriggeredMinute = -1
        }

        if (currentHour === alarmHour24 && currentMinute === Plasmoid.configuration.alarmMinute && !alarmActive && alarmTriggeredMinute === -1) {
            startAlarm()
        }
    }

    function startAlarm() {
        alarmActive = true
        alarmSecondsRemaining = 60
        alarmBlinkState = true
        var now = new Date()
        alarmStartTime = now
        alarmTriggeredMinute = now.getMinutes()
        alarmPlayer.play()
    }

    function stopAlarm() {
        alarmActive = false
        alarmBlinkState = true
        alarmSecondsRemaining = 0
        snoozeActive = false
        alarmDurationTimer.stop()
        alarmPlayer.stop()
    }

    function snoozeAlarm() {
        alarmActive = false
        alarmBlinkState = true
        alarmSecondsRemaining = 0
        alarmDurationTimer.stop()
        alarmPlayer.stop()
        snoozeActive = true
        var now = new Date()
        snoozeUntil = new Date(now.getTime() + Plasmoid.configuration.snoozeMinutes * 60000)
    }

    fullRepresentation: Rectangle {
        id: container
        clip: true
        width: verticalPanel ? Plasmoid.width : (horizontalPanel ? contentRow.width + containerPadding : (planarMode ? Plasmoid.width : contentRow.width + containerPadding))
        height: horizontalPanel ? Plasmoid.height : (verticalPanel ? verticalContent.height + containerPadding : (planarMode ? Plasmoid.height : referenceHeight))
        Layout.minimumWidth: verticalPanel ? Plasmoid.width : (horizontalPanel ? contentRow.width + containerPadding : (planarMode ? planarMinimumWidth : contentRow.width + containerPadding))
        Layout.minimumHeight: horizontalPanel ? Plasmoid.height : (verticalPanel ? verticalContent.height + containerPadding : (planarMode ? planarMinimumHeight : referenceHeight))
        Layout.preferredWidth: verticalPanel ? Plasmoid.width : (planarMode ? Plasmoid.width : contentRow.width + containerPadding)
        Layout.preferredHeight: horizontalPanel ? Plasmoid.height : (planarMode ? Plasmoid.height : (verticalPanel ? verticalContent.height + containerPadding : referenceHeight))
        Layout.fillWidth: verticalPanel || planarMode
        Layout.fillHeight: horizontalPanel || planarMode
        radius: containerRadius
        color: planarMode ? "transparent" : activeBgColor
        border.width: planarMode ? 0 : containerBorderWidth
        border.color: planarMode ? "transparent" : activeBorderColor

        Row {
            id: contentRow
            visible: !verticalPanel
            anchors.centerIn: parent
            spacing: Math.max(2, Math.round(4 * (planarMode ? 1.0 : sizeScale)))
            opacity: (Plasmoid.configuration.flickerEffect ? flickerOpacity : 1.0) * (Plasmoid.configuration.minuteFlicker ? minuteFlickerOpacity : 1.0)
            transform: Scale {
                origin.x: contentRow.width / 2
                origin.y: contentRow.height / 2
                xScale: planarMode ? Math.max(0.5, Math.min(5.0, container.height / 50 * Plasmoid.configuration.fontScale)) : 1.0
                yScale: planarMode ? Math.max(0.5, Math.min(5.0, container.height / 50 * Plasmoid.configuration.fontScale)) : 1.0
            }

            AlarmDot {
                anchors.verticalCenter: parent.verticalCenter
                size: dotSize
                alarmEnabled: Plasmoid.configuration.alarmEnabled
                active: alarmActive
                blinkState: alarmBlinkState
                snoozing: snoozeActive
                mainColor: activeTextColor
                shadowColor: activeShadowColor
                showShadow: Plasmoid.configuration.showShadow
                showGhost: Plasmoid.configuration.ghostSegments
                testOverlayOpacity: lampTestOpacity
            }

            Column {
                spacing: 0

                Row {
                    id: timeRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Plasmoid.configuration.layoutCondensed ? 0 : Math.max(0, Math.round(1 * sizeScale))

                    Repeater {
                        model: timeDigits.length
                        delegate: Item {
                            width: Math.max(4, Math.round((timeDigits[index] === ":" ? (Plasmoid.configuration.showSeconds ? (Plasmoid.configuration.showDate ? 5 : 7) : (Plasmoid.configuration.showDate ? 7 : 9)) : (Plasmoid.configuration.showSeconds ? (Plasmoid.configuration.showDate ? 10 : 14) : (Plasmoid.configuration.showDate ? 12 : 18))) * layoutScale))
                            height: Math.max(6, Math.round((Plasmoid.configuration.showDate ? 13 : 17) * sizeScale))

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: fontVerticalCorrection
                                anchors.right: parent.right
                                anchors.rightMargin: -2
                                font.family: activeFontFamily
                                font.pixelSize: digitFontSize
                                font.bold: activeFontBold
                                font.italic: activeFontItalic
                                renderType: Text.QtRendering
                                color: activeTextColor
                                text: "8"
                                visible: timeDigits[index] !== ":" && (Plasmoid.configuration.ghostSegments || lampTestOpacity > 0)
                                opacity: Math.max(Plasmoid.configuration.ghostSegments ? 0.12 : 0, lampTestOpacity)
                                z: -2
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: 2 + fontVerticalCorrection
                                anchors.right: parent.right
                                anchors.rightMargin: -2
                                font.family: activeFontFamily
                                font.pixelSize: digitFontSize
                                font.bold: activeFontBold
                                font.italic: activeFontItalic
                                renderType: Text.QtRendering
                                color: activeShadowColor
                                text: timeDigits[index]
                                visible: timeDigits[index] !== ":" && Plasmoid.configuration.showShadow
                                opacity: 1 - lampTestOpacity
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.verticalCenterOffset: fontVerticalCorrection
                                anchors.right: parent.right
                                anchors.rightMargin: -2
                                font.family: activeFontFamily
                                font.pixelSize: digitFontSize
                                font.bold: activeFontBold
                                font.italic: activeFontItalic
                                renderType: Text.QtRendering
                                color: activeTextColor
                                text: timeDigits[index]
                                visible: timeDigits[index] !== ":"
                                opacity: 1 - lampTestOpacity
                            }

                            ColonSeparator {
                                anchors.fill: parent
                                visible: timeDigits[index] === ":"
                                fontSize: digitFontSize
                                horizontalNudge: colonHorizontalNudge
                                mainColor: activeTextColor
                                shadowColor: activeShadowColor
                                showShadow: Plasmoid.configuration.showShadow
                                showGhost: Plasmoid.configuration.ghostSegments
                                dotsVisible: !Plasmoid.configuration.blinkDots || dotState
                                testOverlayOpacity: lampTestOpacity
                            }
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth: ampmText.implicitWidth
                        implicitHeight: ampmText.implicitHeight
                        visible: !Plasmoid.configuration.use24HourFormat
                        ShadowedText {
                            id: ampmText
                            anchors.centerIn: parent
                            text: ampmIndicator
                            pixelSize: ampmFontSize
                            fontFamily: activeFontFamily
                            bold: activeFontBold
                            italic: activeFontItalic
                            mainColor: activeTextColor
                            shadowColor: activeShadowColor
                            showShadow: Plasmoid.configuration.showShadow
                            showGhost: Plasmoid.configuration.ghostSegments
                            testOverlayOpacity: lampTestOpacity
                            verticalCorrection: fontVerticalCorrection
                            ghostText: "AM"
                        }
                    }
                }

                Row {
                    id: dateRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 1
                    visible: Plasmoid.configuration.showDate

                    Item {
                        implicitWidth: dateText.implicitWidth
                        implicitHeight: dateText.implicitHeight
                        ShadowedText {
                            id: dateText
                            anchors.centerIn: parent
                            text: currentDateStr
                            pixelSize: dateFontSize
                            fontFamily: activeFontFamily
                            bold: activeFontBold
                            italic: activeFontItalic
                            mainColor: activeTextColor
                            shadowColor: activeShadowColor
                            showShadow: Plasmoid.configuration.showShadow
                            showGhost: Plasmoid.configuration.ghostSegments
                            testOverlayOpacity: lampTestOpacity
                            verticalCorrection: fontVerticalCorrection
                            ghostText: "88/88/88"
                        }
                    }
                }
            }
        }

        Column {
            id: verticalContent
            visible: verticalPanel
            anchors.centerIn: parent
            spacing: Math.max(2, Math.round(3 * vSizeScale))
            opacity: (Plasmoid.configuration.flickerEffect ? flickerOpacity : 1.0) * (Plasmoid.configuration.minuteFlicker ? minuteFlickerOpacity : 1.0)

            AlarmDot {
                anchors.horizontalCenter: parent.horizontalCenter
                size: vDotSize
                alarmEnabled: Plasmoid.configuration.alarmEnabled
                active: alarmActive
                blinkState: alarmBlinkState
                snoozing: snoozeActive
                mainColor: activeTextColor
                shadowColor: activeShadowColor
                showShadow: Plasmoid.configuration.showShadow
                showGhost: Plasmoid.configuration.ghostSegments
                testOverlayOpacity: lampTestOpacity
            }

            Repeater {
                model: timeDigits
                delegate: Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.round(vGroupFontSize * vCharBoxWidthRatio)
                    height: Math.round(vGroupFontSize * 1.0)

                    ShadowedText {
                        anchors.centerIn: parent
                        text: modelData
                        pixelSize: vGroupFontSize
                        fontFamily: activeFontFamily
                        bold: activeFontBold
                        italic: activeFontItalic
                        mainColor: activeTextColor
                        shadowColor: activeShadowColor
                        showShadow: Plasmoid.configuration.showShadow
                        showGhost: Plasmoid.configuration.ghostSegments
                        testOverlayOpacity: lampTestOpacity
                        verticalCorrection: vFontVerticalCorrection
                        ghostText: "8"
                        visible: modelData !== ":"
                    }
                    ColonSeparator {
                        anchors.fill: parent
                        visible: modelData === ":"
                        fontSize: vGroupFontSize
                        mainColor: activeTextColor
                        shadowColor: activeShadowColor
                        showShadow: Plasmoid.configuration.showShadow
                        showGhost: Plasmoid.configuration.ghostSegments
                        dotsVisible: !Plasmoid.configuration.blinkDots || dotState
                        testOverlayOpacity: lampTestOpacity
                    }
                }
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !Plasmoid.configuration.use24HourFormat
                width: Math.round(vGroupFontSize * 0.9)
                height: Math.round(vGroupFontSize * 0.7)

                ShadowedText {
                    id: vAmpmText
                    anchors.centerIn: parent
                    text: ampmIndicator
                    pixelSize: Math.max(5, Math.round(vGroupFontSize * 0.55))
                    fontFamily: activeFontFamily
                    bold: activeFontBold
                    italic: activeFontItalic
                    mainColor: activeTextColor
                    shadowColor: activeShadowColor
                    showShadow: Plasmoid.configuration.showShadow
                    showGhost: Plasmoid.configuration.ghostSegments
                    testOverlayOpacity: lampTestOpacity
                    verticalCorrection: vFontVerticalCorrection
                    ghostText: "AM"
                }
            }

            Repeater {
                model: Plasmoid.configuration.showDate ? currentDateStr.split("") : []
                delegate: Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: Math.round(vGroupFontSize * vCharBoxWidthRatio)
                    height: Math.round(vGroupFontSize * 0.7)

                    ShadowedText {
                        anchors.centerIn: parent
                        text: modelData
                        pixelSize: Math.max(6, Math.round(vGroupFontSize * 0.5))
                        fontFamily: activeFontFamily
                        bold: activeFontBold
                        italic: activeFontItalic
                        mainColor: activeTextColor
                        shadowColor: activeShadowColor
                        showShadow: Plasmoid.configuration.showShadow
                        showGhost: Plasmoid.configuration.ghostSegments
                        testOverlayOpacity: lampTestOpacity
                        verticalCorrection: vFontVerticalCorrection
                        ghostText: modelData === "/" ? "/" : "8"
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (alarmActive) {
                    stopAlarm()
                }
            }
        }

        Canvas {
            id: scanlinesOverlay
            anchors.fill: parent
            visible: Plasmoid.configuration.crtScanlines
            opacity: 0.15
            z: 10

            property real lineSpacing: Math.max(2, Math.round(container.height * 0.04))

            onWidthChanged: requestPaint()
            onHeightChanged: requestPaint()
            onLineSpacingChanged: requestPaint()
            onVisibleChanged: if (visible) requestPaint()

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = "black"
                for (var y = 0; y < height; y += lineSpacing) {
                    ctx.fillRect(0, y, width, 1)
                }
            }
        }
    }
    
    Component.onCompleted: {
        updateClock()
    }
}
