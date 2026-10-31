// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import "../code/colorUtils.js" as ColorUtils

KCM.SimpleKCM {
    id: appearancePage

    property string cfg_clockStyle: "Neon Green"
    property string cfg_fontFamily: "DSEG7"
    property string cfg_fontStyle: "Regular"
    property alias cfg_showShadow: showShadowCheckBox.checked
    property alias cfg_customColor: customColorHolder.value
    property alias cfg_layoutCondensed: layoutCondensedCheckBox.checked
    property alias cfg_fontScale: fontScaleSlider.value

    ClockFonts {
        id: previewFonts
        family: appearancePage.cfg_fontFamily
    }

    readonly property string previewFontFamily: previewFonts.name
    readonly property bool previewFontBold: cfg_fontStyle === "Bold" || cfg_fontStyle === "Bold Italic"
    readonly property bool previewFontItalic: cfg_fontStyle === "Italic" || cfg_fontStyle === "Bold Italic"

    function resetToDefaults() {
        plasmoid.configuration.showSeconds = true
        plasmoid.configuration.blinkDots = true
        plasmoid.configuration.showShadow = true
        plasmoid.configuration.flickerEffect = false
        plasmoid.configuration.ghostSegments = false
        plasmoid.configuration.crtScanlines = false
        plasmoid.configuration.minuteFlicker = false
        plasmoid.configuration.clockStyle = "Neon Green"
        plasmoid.configuration.customColor = "#00ff00"
        plasmoid.configuration.fontStyle = "Regular"
        plasmoid.configuration.fontFamily = "DSEG7"
        plasmoid.configuration.layoutCondensed = false
        plasmoid.configuration.use24HourFormat = true
        plasmoid.configuration.showDate = false
        plasmoid.configuration.alarmEnabled = false
        plasmoid.configuration.alarmHour = 7
        plasmoid.configuration.alarmMinute = 0
        plasmoid.configuration.alarmAmPm = "AM"
        plasmoid.configuration.snoozeMinutes = 5
        plasmoid.configuration.startupTest = false
        plasmoid.configuration.hoverDate = false
        plasmoid.configuration.fontScale = 1.0

        cfg_clockStyle = "Neon Green"
        customColorHolder.value = "#00ff00"
        cfg_fontFamily = "DSEG7"
        cfg_fontStyle = "Regular"
        layoutCondensedCheckBox.checked = false
        fontScaleSlider.value = 1.0
        showShadowCheckBox.checked = true
    }

    Item {
        id: customColorHolder
        visible: false
        property string value: "#00ff00"
    }

    Kirigami.FormLayout {

    RowLayout {
        Kirigami.FormData.label: i18n("Preview:")

        Rectangle {
            id: previewBox
            Layout.preferredWidth: 140
            Layout.preferredHeight: 60
            radius: 10
            color: {
                var c = ColorUtils.getStyleComponents(appearancePage.cfg_clockStyle, appearancePage.cfg_customColor)
                return Qt.rgba(c.bg[0], c.bg[1], c.bg[2], c.bg[3])
            }
            border.width: 2
            border.color: {
                var c = ColorUtils.getStyleComponents(appearancePage.cfg_clockStyle, appearancePage.cfg_customColor)
                return Qt.rgba(c.border[0], c.border[1], c.border[2], c.border[3])
            }

            Text {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 2
                anchors.verticalCenterOffset: 2
                text: "88:88"
                font.family: appearancePage.previewFontFamily
                font.pixelSize: 20
                font.bold: appearancePage.previewFontBold
                font.italic: appearancePage.previewFontItalic
                font.letterSpacing: layoutCondensedCheckBox.checked ? -3 : 0
                renderType: Text.QtRendering
                visible: showShadowCheckBox.checked
                z: -1
                color: {
                    var c = ColorUtils.getStyleComponents(appearancePage.cfg_clockStyle, appearancePage.cfg_customColor)
                    return Qt.rgba(c.shadow[0], c.shadow[1], c.shadow[2], c.shadow[3])
                }
            }

            Text {
                anchors.centerIn: parent
                text: "88:88"
                font.family: appearancePage.previewFontFamily
                font.pixelSize: 20
                font.bold: appearancePage.previewFontBold
                font.italic: appearancePage.previewFontItalic
                font.letterSpacing: layoutCondensedCheckBox.checked ? -3 : 0
                renderType: Text.QtRendering
                color: {
                    var c = ColorUtils.getStyleComponents(appearancePage.cfg_clockStyle, appearancePage.cfg_customColor)
                    return Qt.rgba(c.text[0], c.text[1], c.text[2], c.text[3])
                }
            }
        }
    }

    ComboBox {
        id: clockStyleComboBox
        Kirigami.FormData.label: i18n("Clock style:")
        model: ["Neon Green", "Vintage Amber", "Sapphire Blue", "Ruby Red", "White Led", "VFD Teal", "Nixie Orange", "Retro LCD", "Custom"]
        currentIndex: Math.max(0, model.indexOf(appearancePage.cfg_clockStyle))
        onActivated: appearancePage.cfg_clockStyle = currentText
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Custom color:")
        visible: appearancePage.cfg_clockStyle === "Custom"
        spacing: Kirigami.Units.largeSpacing

        Rectangle {
            id: colorSwatch
            width: Kirigami.Units.gridUnit * 1.5
            height: Kirigami.Units.gridUnit * 1.5
            radius: Kirigami.Units.smallSpacing
            border.width: 1
            border.color: Kirigami.Theme.disabledTextColor
            color: ColorUtils.isValidHexColor(appearancePage.cfg_customColor) ? appearancePage.cfg_customColor : "#00ff00"

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: colorDialog.open()
            }
        }

        Button {
            text: i18n("Choose color…")
            onClicked: colorDialog.open()
        }
    }

    ColorDialog {
        id: colorDialog
        title: i18n("Choose clock color")
        selectedColor: ColorUtils.isValidHexColor(appearancePage.cfg_customColor) ? appearancePage.cfg_customColor : "#00ff00"
        onAccepted: {
            var hex = ColorUtils.rgbToHex(selectedColor.r, selectedColor.g, selectedColor.b)
            appearancePage.cfg_customColor = hex
        }
    }

    ComboBox {
        id: fontFamilyComboBox
        Kirigami.FormData.label: i18n("Font family:")
        model: ["DSEG7", "DotMatrix"]
        currentIndex: Math.max(0, model.indexOf(appearancePage.cfg_fontFamily))
        onActivated: appearancePage.cfg_fontFamily = currentText
    }

    ComboBox {
        id: fontStyleComboBox
        Kirigami.FormData.label: i18n("Font style:")
        model: ["Regular", "Bold", "Italic", "Bold Italic"]
        currentIndex: Math.max(0, model.indexOf(appearancePage.cfg_fontStyle))
        onActivated: appearancePage.cfg_fontStyle = currentText
    }

    CheckBox {
        id: layoutCondensedCheckBox
        Kirigami.FormData.label: i18n("Condensed layout:")
        text: i18n("Pack digits closer together")
    }

    CheckBox {
        id: showShadowCheckBox
        text: i18n("Show shadow")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Font scale:")
        spacing: Kirigami.Units.largeSpacing

        Slider {
            id: fontScaleSlider
            from: 0.5
            to: 2.0
            stepSize: 0.1
        }

        Label {
            text: fontScaleSlider.value.toFixed(1) + "x"
            Layout.preferredWidth: Kirigami.Units.gridUnit * 2.5
        }
    }

    Item { Kirigami.FormData.isSection: true }

    Button {
        Kirigami.FormData.label: i18n("Reset:")
        text: i18n("Reset to defaults")
        icon.name: "edit-undo"
        onClicked: appearancePage.resetToDefaults()
    }

    Item { Kirigami.FormData.isSection: true }

    Kirigami.FormLayout {
        Kirigami.FormData.label: i18n("Support")

        Button {
            text: i18n("Buy me a coffee on Ko-fi")
            onClicked: Qt.openUrlExternally("https://ko-fi.com/retrolcdclock")
        }
    }
    }
}
