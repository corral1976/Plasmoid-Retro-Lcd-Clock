// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    id: effectsPage

    property alias cfg_blinkDots: blinkDotsCheckBox.checked
    property alias cfg_flickerEffect: flickerEffectCheckBox.checked
    property alias cfg_ghostSegments: ghostSegmentsCheckBox.checked
    property alias cfg_crtScanlines: crtScanlinesCheckBox.checked
    property alias cfg_minuteFlicker: minuteFlickerCheckBox.checked
    property alias cfg_startupTest: startupTestCheckBox.checked

    Kirigami.FormLayout {

    CheckBox {
        id: blinkDotsCheckBox
        Kirigami.FormData.label: i18n("Colon:")
        text: i18n("Blinking dots")
    }
    CheckBox {
        id: flickerEffectCheckBox
        Kirigami.FormData.label: i18n("Continuous:")
        text: i18n("Flicker effect")
    }
    CheckBox {
        id: minuteFlickerCheckBox
        text: i18n("Flicker on minute change")
    }
    CheckBox {
        id: startupTestCheckBox
        Kirigami.FormData.label: i18n("Startup:")
        text: i18n("Lamp test on load")
    }

    Item { Kirigami.FormData.isSection: true }

    CheckBox {
        id: ghostSegmentsCheckBox
        Kirigami.FormData.label: i18n("LCD panel look:")
        text: i18n("Ghost segments")
    }
    CheckBox {
        id: crtScanlinesCheckBox
        text: i18n("CRT scanlines")
    }
    }
}
