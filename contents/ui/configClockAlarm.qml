// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: clockAlarmPage

    property bool cfg_use24HourFormat: true
    property string cfg_alarmAmPm: "AM"
    property alias cfg_showSeconds: showSecondsCheckBox.checked
    property alias cfg_showDate: showDateCheckBox.checked
    property alias cfg_alarmEnabled: alarmEnabledCheckBox.checked
    property alias cfg_alarmHour: alarmHourSpinBox.value
    property alias cfg_alarmMinute: alarmMinuteSpinBox.value
    property alias cfg_snoozeMinutes: snoozeMinutesSpinBox.value

    function switchHourFormat(use24) {
        if (use24 === cfg_use24HourFormat) {
            return
        }
        var hour = cfg_alarmHour
        var converted
        var ampm = cfg_alarmAmPm
        if (use24) {
            converted = hour % 12 + (cfg_alarmAmPm === "PM" ? 12 : 0)
        } else {
            ampm = hour >= 12 ? "PM" : "AM"
            converted = hour % 12 === 0 ? 12 : hour % 12
        }
        cfg_use24HourFormat = use24
        cfg_alarmHour = converted
        cfg_alarmAmPm = ampm
    }

    Kirigami.FormLayout {

    CheckBox {
        id: showSecondsCheckBox
        Kirigami.FormData.label: i18n("Format:")
        text: i18n("Show seconds")
    }
    CheckBox {
        id: use24HourFormatCheckBox
        text: i18n("24-hour format")
        checked: clockAlarmPage.cfg_use24HourFormat
        onToggled: clockAlarmPage.switchHourFormat(checked)
    }
    CheckBox {
        id: showDateCheckBox
        text: i18n("Show date")
    }

    Item { Kirigami.FormData.isSection: true }

    CheckBox {
        id: alarmEnabledCheckBox
        Kirigami.FormData.label: i18n("Alarm:")
        text: i18n("Alarm enabled")
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Alarm time:")
        spacing: Kirigami.Units.smallSpacing

        SpinBox {
            id: alarmHourSpinBox
            from: clockAlarmPage.cfg_use24HourFormat ? 0 : 1
            to: clockAlarmPage.cfg_use24HourFormat ? 23 : 12
            editable: true
            wrap: true
        }

        Label { text: ":" }

        SpinBox {
            id: alarmMinuteSpinBox
            from: 0
            to: 59
            editable: true
            wrap: true
        }

        ComboBox {
            id: alarmAmPmComboBox
            visible: !clockAlarmPage.cfg_use24HourFormat
            model: ["AM", "PM"]
            Layout.preferredWidth: Kirigami.Units.gridUnit * 4.5
            currentIndex: Math.max(0, model.indexOf(clockAlarmPage.cfg_alarmAmPm))
            onActivated: clockAlarmPage.cfg_alarmAmPm = currentText
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Snooze duration:")
        spacing: Kirigami.Units.smallSpacing

        SpinBox {
            id: snoozeMinutesSpinBox
            from: 1
            to: 30
            editable: true
        }

        Label { text: i18n("minutes") }
    }
    }
}
