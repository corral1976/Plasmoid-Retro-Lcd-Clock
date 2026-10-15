// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmaCore.Dialog {
    id: root

    property string text
    property color backgroundColor: "black"
    property color borderColor: "white"
    property color textColor: "white"

    type: PlasmaCore.Dialog.Tooltip
    backgroundHints: PlasmaCore.Dialog.NoBackground
    flags: Qt.ToolTip | Qt.WindowTransparentForInput | Qt.WindowDoesNotAcceptFocus | Qt.WindowStaysOnTopHint

    mainItem: Rectangle {
        implicitWidth: label.implicitWidth + Kirigami.Units.gridUnit * 1.5
        implicitHeight: label.implicitHeight + Kirigami.Units.gridUnit
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: 2
        radius: Kirigami.Units.smallSpacing * 2

        Text {
            id: label
            anchors.centerIn: parent
            text: root.text
            color: root.textColor
        }
    }
}
