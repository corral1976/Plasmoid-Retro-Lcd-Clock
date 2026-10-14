// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: clockAlarmPage

    property alias cfg_showSeconds: showSecondsCheckBox.checked
    property alias cfg_use24HourFormat: use24HourFormatCheckBox.checked
    property alias cfg_showDate: showDateCheckBox.checked
    property alias cfg_alarmEnabled: alarmEnabledCheckBox.checked
    property alias cfg_alarmHour: alarmHourSpinBox.value
    property alias cfg_alarmMinute: alarmMinuteSpinBox.value
    property alias cfg_snoozeMinutes: snoozeMinutesSpinBox.value

    Kirigami.FormLayout {

    CheckBox {
        id: showSecondsCheckBox
        Kirigami.FormData.label: i18n("Format:")
        text: i18n("Show seconds")
    }
    CheckBox {
        id: use24HourFormatCheckBox
        text: i18n("24-hour format")
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
        spacing: 5

        SpinBox {
            id: alarmHourSpinBox
            from: plasmoid.configuration.use24HourFormat ? 0 : 1
            to: plasmoid.configuration.use24HourFormat ? 23 : 12
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
            visible: !plasmoid.configuration.use24HourFormat
            model: ["AM", "PM"]
            Layout.preferredWidth: 80
            currentIndex: {
                var idx = model.indexOf(plasmoid.configuration.alarmAmPm)
                return idx >= 0 ? idx : 0
            }
            onCurrentTextChanged: plasmoid.configuration.alarmAmPm = currentText
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Snooze duration:")
        spacing: 5

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
