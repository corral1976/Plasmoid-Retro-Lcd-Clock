// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-color"
        source: "configAppearance.qml"
    }
    ConfigCategory {
        name: i18n("Effects")
        icon: "preferences-desktop-theme"
        source: "configEffects.qml"
    }
    ConfigCategory {
        name: i18n("Clock and Alarm")
        icon: "preferences-system-time"
        source: "configClockAlarm.qml"
    }
}
