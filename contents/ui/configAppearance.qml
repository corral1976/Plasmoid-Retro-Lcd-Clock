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

    property alias cfg_showShadow: showShadowCheckBox.checked
    property alias cfg_customColor: customColorHolder.value
    property alias cfg_layoutCondensed: layoutCondensedCheckBox.checked
    property alias cfg_fontScale: fontScaleSlider.value

    FontLoader {
        id: previewFontRegular
        source: "../assets/DSEG7Classic-Regular.ttf"
    }
    FontLoader {
        id: previewFontBold
        source: "../assets/DSEG7Classic-Bold.ttf"
    }
    FontLoader {
        id: previewFontItalic
        source: "../assets/DSEG7Classic-Italic.ttf"
    }
    FontLoader {
        id: previewFontBoldItalic
        source: "../assets/DSEG7Classic-BoldItalic.ttf"
    }
    FontLoader {
        id: previewFontDotMatrixRegular
        source: "../assets/DotMatrix-Regular.ttf"
    }
    FontLoader {
        id: previewFontDotMatrixBold
        source: "../assets/DotMatrix-Bold.ttf"
    }
    FontLoader {
        id: previewFontDotMatrixItalic
        source: "../assets/DotMatrix-Italic.ttf"
    }
    FontLoader {
        id: previewFontDotMatrixBoldItalic
        source: "../assets/DotMatrix-BoldItalic.ttf"
    }

    readonly property string previewFontFamily: {
        if (fontFamilyComboBox.currentText === "DotMatrix") {
            return previewFontDotMatrixRegular.status === FontLoader.Ready ? previewFontDotMatrixRegular.name : "monospace"
        }
        return previewFontRegular.status === FontLoader.Ready ? previewFontRegular.name : "monospace"
    }
    readonly property bool previewFontBold: fontStyleComboBox.currentText === "Bold" || fontStyleComboBox.currentText === "Bold Italic"
    readonly property bool previewFontItalic: fontStyleComboBox.currentText === "Italic" || fontStyleComboBox.currentText === "Bold Italic"

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
        plasmoid.configuration.fontScale = 1.0

        clockStyleComboBox.currentIndex = clockStyleComboBox.model.indexOf("Neon Green")
        customColorHolder.value = "#00ff00"
        fontFamilyComboBox.currentIndex = fontFamilyComboBox.model.indexOf("DSEG7")
        fontStyleComboBox.currentIndex = fontStyleComboBox.model.indexOf("Regular")
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
                var c = ColorUtils.getStyleComponents(clockStyleComboBox.currentText, appearancePage.cfg_customColor)
                return Qt.rgba(c.bg[0], c.bg[1], c.bg[2], c.bg[3])
            }
            border.width: 2
            border.color: {
                var c = ColorUtils.getStyleComponents(clockStyleComboBox.currentText, appearancePage.cfg_customColor)
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
                    var c = ColorUtils.getStyleComponents(clockStyleComboBox.currentText, appearancePage.cfg_customColor)
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
                    var c = ColorUtils.getStyleComponents(clockStyleComboBox.currentText, appearancePage.cfg_customColor)
                    return Qt.rgba(c.text[0], c.text[1], c.text[2], c.text[3])
                }
            }
        }
    }

    ComboBox {
        id: clockStyleComboBox
        Kirigami.FormData.label: i18n("Clock style:")
        model: ["Neon Green", "Vintage Amber", "Sapphire Blue", "Ruby Red", "White Led", "VFD Teal", "Nixie Orange", "Retro LCD", "Custom"]
        currentIndex: {
            var idx = model.indexOf(plasmoid.configuration.clockStyle)
            return idx >= 0 ? idx : 0
        }
        onCurrentTextChanged: {
            plasmoid.configuration.clockStyle = currentText
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Custom color:")
        visible: clockStyleComboBox.currentText === "Custom"
        spacing: 8

        Rectangle {
            id: colorSwatch
            width: 28
            height: 28
            radius: 4
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
        currentIndex: {
            var idx = model.indexOf(plasmoid.configuration.fontFamily)
            return idx >= 0 ? idx : 0
        }
        onCurrentTextChanged: {
            plasmoid.configuration.fontFamily = currentText
        }
    }

    ComboBox {
        id: fontStyleComboBox
        Kirigami.FormData.label: i18n("Font style:")
        model: ["Regular", "Bold", "Italic", "Bold Italic"]
        currentIndex: {
            var idx = model.indexOf(plasmoid.configuration.fontStyle)
            return idx >= 0 ? idx : 0
        }
        onCurrentTextChanged: {
            plasmoid.configuration.fontStyle = currentText
        }
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
        spacing: 8

        Slider {
            id: fontScaleSlider
            from: 0.5
            to: 2.0
            stepSize: 0.1
        }

        Label {
            text: fontScaleSlider.value.toFixed(1) + "x"
            Layout.preferredWidth: 40
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
