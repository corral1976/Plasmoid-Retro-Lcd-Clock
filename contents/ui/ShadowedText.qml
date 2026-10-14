// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

Item {
    id: root

    property string text: ""
    property int pixelSize: 12
    property string fontFamily: "monospace"
    property bool bold: false
    property bool italic: false
    property color mainColor: "white"
    property color shadowColor: "black"
    property bool showShadow: true
    property bool dimmed: false
    property string ghostText: ""
    property bool showGhost: false
    property real ghostOpacity: 0.12
    property real testOverlayOpacity: 0.0
    property real verticalCorrection: 0

    implicitWidth: mainText.implicitWidth
    implicitHeight: mainText.implicitHeight

    Text {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.verticalCorrection
        font.family: root.fontFamily
        font.pixelSize: root.pixelSize
        font.bold: root.bold
        font.italic: root.italic
        renderType: Text.QtRendering
        color: root.mainColor
        text: root.ghostText
        visible: (root.showGhost || root.testOverlayOpacity > 0) && root.ghostText.length > 0
        opacity: Math.max(root.showGhost ? root.ghostOpacity : 0, root.testOverlayOpacity)
        z: -2
    }

    Text {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 2
        anchors.verticalCenterOffset: 2 + root.verticalCorrection
        font.family: root.fontFamily
        font.pixelSize: root.pixelSize
        font.bold: root.bold
        font.italic: root.italic
        renderType: Text.QtRendering
        color: root.shadowColor
        text: root.text
        visible: root.showShadow
        opacity: root.dimmed ? 0 : (1 - root.testOverlayOpacity)
        z: -1
    }

    Text {
        id: mainText
        anchors.centerIn: parent
        anchors.verticalCenterOffset: root.verticalCorrection
        font.family: root.fontFamily
        font.pixelSize: root.pixelSize
        font.bold: root.bold
        font.italic: root.italic
        renderType: Text.QtRendering
        color: root.mainColor
        text: root.text
        opacity: root.dimmed ? 0 : (1 - root.testOverlayOpacity)
    }
}
