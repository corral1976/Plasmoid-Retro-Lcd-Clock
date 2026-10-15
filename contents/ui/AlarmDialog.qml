// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore

PlasmaCore.Dialog {
    id: root

    property color backgroundColor: "black"
    property color borderColor: "white"
    property color textColor: "white"
    property string fontFamily: "monospace"
    property int snoozeMinutes: 5

    signal stopRequested()
    signal snoozeRequested()

    flags: Qt.WindowStaysOnTopHint

    component ThemedButton: Basic.Button {
        id: control

        property color fillColor: "black"
        property color lineColor: "white"
        property color labelColor: "white"

        padding: Kirigami.Units.largeSpacing
        Layout.minimumWidth: Kirigami.Units.gridUnit * 5

        background: Rectangle {
            radius: Kirigami.Units.smallSpacing
            color: control.hovered || control.visualFocus
                ? Qt.tint(control.fillColor, Qt.rgba(control.labelColor.r, control.labelColor.g, control.labelColor.b, 0.25))
                : control.fillColor
            border.color: control.lineColor
            border.width: control.visualFocus ? 2 : 1
        }

        contentItem: Text {
            text: control.text
            color: control.labelColor
            font: control.font
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    mainItem: Rectangle {
        implicitWidth: dialogLayout.implicitWidth + Kirigami.Units.largeSpacing * 4
        implicitHeight: dialogLayout.implicitHeight + Kirigami.Units.largeSpacing * 4
        color: root.backgroundColor
        border.color: root.borderColor
        border.width: 2
        radius: Kirigami.Units.smallSpacing * 2

        ColumnLayout {
            id: dialogLayout
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing * 2
            spacing: Kirigami.Units.largeSpacing

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: i18n("Alarm")
                font.family: root.fontFamily
                font.bold: true
                font.pixelSize: Kirigami.Units.gridUnit
                color: root.textColor
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.largeSpacing

                ThemedButton {
                    text: i18n("Stop")
                    fillColor: root.backgroundColor
                    lineColor: root.borderColor
                    labelColor: root.textColor
                    onClicked: root.stopRequested()
                }

                ThemedButton {
                    text: i18nc("Snooze the alarm for N minutes", "Snooze (%1 min)", root.snoozeMinutes)
                    fillColor: root.backgroundColor
                    lineColor: root.borderColor
                    labelColor: root.textColor
                    onClicked: root.snoozeRequested()
                }
            }
        }
    }
}
