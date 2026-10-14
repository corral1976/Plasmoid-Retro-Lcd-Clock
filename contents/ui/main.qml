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
            text: i18nc("Snooze the currently ringing alarm", "Snooze alarm (%1 min)", cfg_snoozeMinutes)
            icon.name: "media-playback-pause"
            visible: alarmActive
            onTriggered: snoozeAlarm()
        }
    ]

    FontLoader {
        id: fontRegular
        source: "../assets/DSEG7Classic-Regular.ttf"
    }
    FontLoader {
        id: fontBold
        source: "../assets/DSEG7Classic-Bold.ttf"
    }
    FontLoader {
        id: fontItalic
        source: "../assets/DSEG7Classic-Italic.ttf"
    }
    FontLoader {
        id: fontBoldItalic
        source: "../assets/DSEG7Classic-BoldItalic.ttf"
    }
    FontLoader {
        id: fontDotMatrixRegular
        source: "../assets/DotMatrix-Regular.ttf"
    }
    FontLoader {
        id: fontDotMatrixBold
        source: "../assets/DotMatrix-Bold.ttf"
    }
    FontLoader {
        id: fontDotMatrixItalic
        source: "../assets/DotMatrix-Italic.ttf"
    }
    FontLoader {
        id: fontDotMatrixBoldItalic
        source: "../assets/DotMatrix-BoldItalic.ttf"
    }

    readonly property string activeFontFamily: {
        if (cfg_fontFamily === "DotMatrix") {
            return fontDotMatrixRegular.status === FontLoader.Ready ? fontDotMatrixRegular.name : "monospace"
        }
        return fontRegular.status === FontLoader.Ready ? fontRegular.name : "monospace"
    }
    readonly property bool activeFontBold: cfg_fontStyle === "Bold" || cfg_fontStyle === "Bold Italic"
    readonly property bool activeFontItalic: cfg_fontStyle === "Italic" || cfg_fontStyle === "Bold Italic"
    readonly property real fontVerticalCorrection: cfg_fontFamily === "DotMatrix" ? Math.round(digitFontSize * 0.10) : 0
    readonly property real vFontVerticalCorrection: cfg_fontFamily === "DotMatrix" ? Math.round(vGroupFontSize * 0.10) : 0

    readonly property bool horizontalPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal
    readonly property bool verticalPanel: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool planarMode: !horizontalPanel && !verticalPanel
    readonly property real referenceHeight: 120
    readonly property int naturalWidthEstimate: {
        var digitCount = cfg_showSeconds ? 6 : 4
        var colonCount = cfg_showSeconds ? 2 : 1
        var estimate = digitCount * 18 + colonCount * 9 + (digitCount + colonCount - 1) + 24
        if (!cfg_use24HourFormat) {
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
        return baseScale * cfg_fontScale
    }
    readonly property real vReferenceThickness: 40
    readonly property real vSizeScale: {
        if (verticalPanel && Plasmoid.width > 0) {
            return Math.max(0.4, Math.min(1.6, Plasmoid.width / vReferenceThickness)) * cfg_fontScale
        } else if (planarMode) {
            return Math.max(0.4, Math.min(1.6, Math.min(Plasmoid.width, Plasmoid.height) / vReferenceThickness)) * cfg_fontScale
        }
        return cfg_fontScale
    }
    readonly property int vGroupFontSize: Math.max(8, Math.round(15 * vSizeScale))
    readonly property int vDotSize: Math.max(1, Math.round(2 * vSizeScale))
    readonly property real condensedFactor: cfg_layoutCondensed ? 0.82 : 1.0
    readonly property real layoutScale: sizeScale * condensedFactor

    readonly property real containerRadius: 16
    readonly property real containerBorderWidth: 2
    readonly property int planarMinimumWidth: 20
    readonly property int planarMinimumHeight: 15
    readonly property real vCharBoxWidthRatio: 0.7
    readonly property real colonDotSizeRatio: 0.09
    readonly property real colonDotSpacingRatio: 0.2
    readonly property real colonHorizontalNudge: Math.round(digitFontSize * 0.15 * condensedFactor)
    readonly property int containerPadding: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(4, Math.round(Plasmoid.height * 0.1))
        }
        return Math.max(6, Math.round(24 * sizeScale))
    }
    readonly property int digitFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(4, Math.round(Plasmoid.height * 0.4 * cfg_fontScale))
        }
        return Math.max(6, Math.round((cfg_showDate ? 11 : 15) * sizeScale))
    }
    readonly property int ampmFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(3, Math.round(Plasmoid.height * 0.3 * cfg_fontScale))
        }
        return Math.max(5, Math.round((cfg_showDate ? 8 : 12) * sizeScale))
    }
    readonly property int dateFontSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(3, Math.round(Plasmoid.height * 0.2 * cfg_fontScale))
        }
        return Math.max(5, Math.round(8 * sizeScale))
    }
    readonly property int dotSize: {
        if (planarMode && Plasmoid.height > 0) {
            return Math.max(1, Math.round(Plasmoid.height * 0.0375 * cfg_fontScale))
        }
        return Math.max(1, Math.round(2 * sizeScale))
    }
    
    property bool cfg_showSeconds: plasmoid.configuration.showSeconds !== undefined ? plasmoid.configuration.showSeconds : true
    property bool cfg_blinkDots: plasmoid.configuration.blinkDots !== undefined ? plasmoid.configuration.blinkDots : true
    property bool cfg_showShadow: plasmoid.configuration.showShadow !== undefined ? plasmoid.configuration.showShadow : true
    property bool cfg_flickerEffect: plasmoid.configuration.flickerEffect !== undefined ? plasmoid.configuration.flickerEffect : false
    property bool cfg_ghostSegments: plasmoid.configuration.ghostSegments !== undefined ? plasmoid.configuration.ghostSegments : false
    property bool cfg_crtScanlines: plasmoid.configuration.crtScanlines !== undefined ? plasmoid.configuration.crtScanlines : false
    property bool cfg_minuteFlicker: plasmoid.configuration.minuteFlicker !== undefined ? plasmoid.configuration.minuteFlicker : false
    property string cfg_clockStyle: {
        var style = plasmoid.configuration.clockStyle !== undefined ? plasmoid.configuration.clockStyle : "Neon Green"
        var validStyles = ["Neon Green", "Vintage Amber", "Sapphire Blue", "Ruby Red", "White Led", "VFD Teal", "Nixie Orange", "Retro LCD", "Custom"]
        if (validStyles.indexOf(style) === -1) {
            style = "Neon Green"
        }
        return style
    }
    property string cfg_customColor: {
        var hex = plasmoid.configuration.customColor !== undefined ? plasmoid.configuration.customColor : "#00ff00"
        return ColorUtils.isValidHexColor(hex) ? hex : "#00ff00"
    }
    property string cfg_fontStyle: {
        var fStyle = plasmoid.configuration.fontStyle !== undefined ? plasmoid.configuration.fontStyle : "Regular"
        var validFontStyles = ["Regular", "Bold", "Italic", "Bold Italic"]
        if (validFontStyles.indexOf(fStyle) === -1) {
            fStyle = "Regular"
        }
        return fStyle
    }
    property string cfg_fontFamily: {
        var family = plasmoid.configuration.fontFamily !== undefined ? plasmoid.configuration.fontFamily : "DSEG7"
        var validFontFamilies = ["DSEG7", "DotMatrix"]
        if (validFontFamilies.indexOf(family) === -1) {
            family = "DSEG7"
        }
        return family
    }
    property bool cfg_layoutCondensed: plasmoid.configuration.layoutCondensed !== undefined ? plasmoid.configuration.layoutCondensed : false
    property bool cfg_use24HourFormat: plasmoid.configuration.use24HourFormat !== undefined ? plasmoid.configuration.use24HourFormat : true
    property bool cfg_showDate: plasmoid.configuration.showDate !== undefined ? plasmoid.configuration.showDate : false
    property bool cfg_alarmEnabled: plasmoid.configuration.alarmEnabled !== undefined ? plasmoid.configuration.alarmEnabled : false
    property int cfg_alarmHour: plasmoid.configuration.alarmHour !== undefined ? plasmoid.configuration.alarmHour : 7
    property int cfg_alarmMinute: plasmoid.configuration.alarmMinute !== undefined ? plasmoid.configuration.alarmMinute : 0
    property string cfg_alarmAmPm: plasmoid.configuration.alarmAmPm !== undefined ? plasmoid.configuration.alarmAmPm : "AM"
    property int cfg_snoozeMinutes: plasmoid.configuration.snoozeMinutes !== undefined ? plasmoid.configuration.snoozeMinutes : 5
    property bool cfg_startupTest: plasmoid.configuration.startupTest !== undefined ? plasmoid.configuration.startupTest : false
    property real cfg_fontScale: plasmoid.configuration.fontScale !== undefined ? plasmoid.configuration.fontScale : 1.0

    readonly property var activeStyle: ColorUtils.getStyleComponents(cfg_clockStyle, cfg_customColor)
    readonly property color activeBgColor: Qt.rgba(activeStyle.bg[0], activeStyle.bg[1], activeStyle.bg[2], activeStyle.bg[3])
    readonly property color activeTextColor: Qt.rgba(activeStyle.text[0], activeStyle.text[1], activeStyle.text[2], activeStyle.text[3])
    readonly property color activeShadowColor: Qt.rgba(activeStyle.shadow[0], activeStyle.shadow[1], activeStyle.shadow[2], activeStyle.shadow[3])
    readonly property color activeBorderColor: Qt.rgba(activeStyle.border[0], activeStyle.border[1], activeStyle.border[2], activeStyle.border[3])

    property string currentTimeStr: "88:88:88"
    property string currentDateStr: "88/88/88"
    property string ampmIndicator: ""
    property bool dotState: true
    property real flickerOpacity: 1.0
    property real minuteFlickerOpacity: 1.0
    property real lampTestOpacity: cfg_startupTest ? 1.0 : 0.0
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

    PlasmaCore.Dialog {
        id: alarmDialog
        visible: alarmActive
        visualParent: container
        location: Plasmoid.location
        flags: Qt.WindowStaysOnTopHint

        mainItem: Item {
            width: 230
            height: 110

            Rectangle {
                anchors.fill: parent
                color: activeBgColor
                border.color: activeBorderColor
                border.width: 2
                radius: 8

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 12

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: i18n("Alarm")
                        font.family: activeFontFamily
                        font.bold: true
                        font.pixelSize: 18
                        color: activeTextColor
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 12

                        Rectangle {
                            width: 90
                            height: 32
                            radius: 4
                            color: stopArea.containsMouse ? Qt.lighter(activeBgColor, 1.6) : activeBgColor
                            border.color: activeBorderColor
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: i18n("Stop")
                                color: activeTextColor
                            }

                            MouseArea {
                                id: stopArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: stopAlarm()
                            }
                        }

                        Rectangle {
                            width: 110
                            height: 32
                            radius: 4
                            color: snoozeArea.containsMouse ? Qt.lighter(activeBgColor, 1.6) : activeBgColor
                            border.color: activeBorderColor
                            border.width: 1

                            Text {
                                anchors.centerIn: parent
                                text: i18nc("Snooze the alarm for N minutes", "Snooze (%1 min)", cfg_snoozeMinutes)
                                color: activeTextColor
                                font.pixelSize: 11
                            }

                            MouseArea {
                                id: snoozeArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: snoozeAlarm()
                            }
                        }
                    }
                }
            }
        }
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
        running: cfg_blinkDots
        onTriggered: {
            dotState = !dotState
        }
    }

    Timer {
        id: flickerTimer
        interval: 120
        repeat: true
        running: cfg_flickerEffect
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
        running: cfg_startupTest
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

        if (!cfg_use24HourFormat) {
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

        if (cfg_showSeconds) {
            timeDigits = [h1.toString(), h2.toString(), ":", m1.toString(), m2.toString(), ":", s1.toString(), s2.toString()]
        } else {
            timeDigits = [h1.toString(), h2.toString(), ":", m1.toString(), m2.toString()]
        }

        currentDateStr = d1.toString() + d2.toString() + "/" + mo1.toString() + mo2.toString() + "/" + year
        currentTimeStr = timeDigits.join("")

        if (cfg_minuteFlicker && lastMinute !== -1 && minutes !== lastMinute) {
            minuteFlickerAnimation.restart()
        }
        lastMinute = minutes
    }

    function checkAlarm() {
        if (!cfg_alarmEnabled) {
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

        var alarmHour24 = cfg_alarmHour
        if (!cfg_use24HourFormat) {
            if (cfg_alarmAmPm === "PM" && cfg_alarmHour !== 12) {
                alarmHour24 = cfg_alarmHour + 12
            } else if (cfg_alarmAmPm === "AM" && cfg_alarmHour === 12) {
                alarmHour24 = 0
            }
        }

        if (currentMinute !== alarmTriggeredMinute) {
            alarmTriggeredMinute = -1
        }

        if (currentHour === alarmHour24 && currentMinute === cfg_alarmMinute && !alarmActive && alarmTriggeredMinute === -1) {
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
        snoozeUntil = new Date(now.getTime() + cfg_snoozeMinutes * 60000)
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
            opacity: (cfg_flickerEffect ? flickerOpacity : 1.0) * (cfg_minuteFlicker ? minuteFlickerOpacity : 1.0)
            transform: Scale {
                origin.x: contentRow.width / 2
                origin.y: contentRow.height / 2
                xScale: planarMode ? Math.max(0.5, Math.min(5.0, container.height / 50 * cfg_fontScale)) : 1.0
                yScale: planarMode ? Math.max(0.5, Math.min(5.0, container.height / 50 * cfg_fontScale)) : 1.0
            }

            AlarmDot {
                anchors.verticalCenter: parent.verticalCenter
                size: dotSize
                enabled: cfg_alarmEnabled
                active: alarmActive
                blinkState: alarmBlinkState
                snoozing: snoozeActive
                mainColor: activeTextColor
                shadowColor: activeShadowColor
                showShadow: cfg_showShadow
                showGhost: cfg_ghostSegments
                testOverlayOpacity: lampTestOpacity
            }

            Column {
                spacing: 0

                Row {
                    id: timeRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: cfg_layoutCondensed ? 0 : Math.max(0, Math.round(1 * sizeScale))

                    Repeater {
                        model: timeDigits.length
                        delegate: Item {
                            width: Math.max(4, Math.round((timeDigits[index] === ":" ? (cfg_showSeconds ? (cfg_showDate ? 5 : 7) : (cfg_showDate ? 7 : 9)) : (cfg_showSeconds ? (cfg_showDate ? 10 : 14) : (cfg_showDate ? 12 : 18))) * layoutScale))
                            height: Math.max(6, Math.round((cfg_showDate ? 13 : 17) * sizeScale))

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
                                visible: timeDigits[index] !== ":" && (cfg_ghostSegments || lampTestOpacity > 0)
                                opacity: Math.max(cfg_ghostSegments ? 0.12 : 0, lampTestOpacity)
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
                                visible: timeDigits[index] !== ":" && cfg_showShadow
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

                            Column {
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: colonHorizontalNudge
                                spacing: Math.round(digitFontSize * colonDotSpacingRatio)
                                visible: timeDigits[index] === ":" && (cfg_ghostSegments || lampTestOpacity > 0)

                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeTextColor
                                    opacity: Math.max(cfg_ghostSegments ? 0.12 : 0, lampTestOpacity)
                                }
                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeTextColor
                                    opacity: Math.max(cfg_ghostSegments ? 0.12 : 0, lampTestOpacity)
                                }
                            }
                            Column {
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: colonHorizontalNudge
                                spacing: Math.round(digitFontSize * colonDotSpacingRatio)
                                visible: timeDigits[index] === ":"

                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeTextColor
                                    visible: !cfg_blinkDots || dotState
                                    opacity: 1 - lampTestOpacity
                                }
                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeTextColor
                                    visible: !cfg_blinkDots || dotState
                                    opacity: 1 - lampTestOpacity
                                }
                            }
                            Column {
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: 2 + colonHorizontalNudge
                                anchors.verticalCenterOffset: 2
                                spacing: Math.round(digitFontSize * colonDotSpacingRatio)
                                visible: timeDigits[index] === ":" && cfg_showShadow

                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeShadowColor
                                    visible: !cfg_blinkDots || dotState
                                    opacity: 1 - lampTestOpacity
                                }
                                Rectangle {
                                    width: Math.round(digitFontSize * colonDotSizeRatio)
                                    height: Math.round(digitFontSize * colonDotSizeRatio)
                                    radius: width / 2
                                    color: activeShadowColor
                                    visible: !cfg_blinkDots || dotState
                                    opacity: 1 - lampTestOpacity
                                }
                            }
                        }
                    }

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth: ampmText.implicitWidth
                        implicitHeight: ampmText.implicitHeight
                        visible: !cfg_use24HourFormat
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
                            showShadow: cfg_showShadow
                            showGhost: cfg_ghostSegments
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
                    visible: cfg_showDate

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
                            showShadow: cfg_showShadow
                            showGhost: cfg_ghostSegments
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
            opacity: (cfg_flickerEffect ? flickerOpacity : 1.0) * (cfg_minuteFlicker ? minuteFlickerOpacity : 1.0)

            AlarmDot {
                anchors.horizontalCenter: parent.horizontalCenter
                size: vDotSize
                enabled: cfg_alarmEnabled
                active: alarmActive
                blinkState: alarmBlinkState
                snoozing: snoozeActive
                mainColor: activeTextColor
                shadowColor: activeShadowColor
                showShadow: cfg_showShadow
                showGhost: cfg_ghostSegments
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
                        showShadow: cfg_showShadow
                        showGhost: cfg_ghostSegments
                        testOverlayOpacity: lampTestOpacity
                        verticalCorrection: vFontVerticalCorrection
                        ghostText: "8"
                        visible: modelData !== ":"
                    }
                    Column {
                        anchors.centerIn: parent
                        spacing: Math.round(vGroupFontSize * colonDotSpacingRatio)
                        visible: modelData === ":" && (cfg_ghostSegments || lampTestOpacity > 0)

                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeTextColor
                            opacity: Math.max(cfg_ghostSegments ? 0.12 : 0, lampTestOpacity)
                        }
                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeTextColor
                            opacity: Math.max(cfg_ghostSegments ? 0.12 : 0, lampTestOpacity)
                        }
                    }
                    Column {
                        anchors.centerIn: parent
                        spacing: Math.round(vGroupFontSize * colonDotSpacingRatio)
                        visible: modelData === ":"

                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeTextColor
                            visible: !cfg_blinkDots || dotState
                            opacity: 1 - lampTestOpacity
                        }
                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeTextColor
                            visible: !cfg_blinkDots || dotState
                            opacity: 1 - lampTestOpacity
                        }
                    }
                    Column {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: 2
                        anchors.verticalCenterOffset: 2
                        spacing: Math.round(vGroupFontSize * colonDotSpacingRatio)
                        visible: modelData === ":" && cfg_showShadow

                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeShadowColor
                            visible: !cfg_blinkDots || dotState
                            opacity: 1 - lampTestOpacity
                        }
                        Rectangle {
                            width: Math.round(vGroupFontSize * colonDotSizeRatio)
                            height: Math.round(vGroupFontSize * colonDotSizeRatio)
                            radius: width / 2
                            color: activeShadowColor
                            visible: !cfg_blinkDots || dotState
                            opacity: 1 - lampTestOpacity
                        }
                    }
                }
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !cfg_use24HourFormat
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
                    showShadow: cfg_showShadow
                    showGhost: cfg_ghostSegments
                    testOverlayOpacity: lampTestOpacity
                    verticalCorrection: vFontVerticalCorrection
                    ghostText: "AM"
                }
            }

            Repeater {
                model: cfg_showDate ? currentDateStr.split("") : []
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
                        showShadow: cfg_showShadow
                        showGhost: cfg_ghostSegments
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
            visible: cfg_crtScanlines
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
