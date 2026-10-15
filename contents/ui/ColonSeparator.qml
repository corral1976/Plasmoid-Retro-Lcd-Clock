// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

Item {
    id: root

    property real fontSize: 12
    property real horizontalNudge: 0
    property color mainColor: "white"
    property color shadowColor: "black"
    property bool showShadow: true
    property bool showGhost: false
    property bool dotsVisible: true
    property real ghostOpacity: 0.12
    property real testOverlayOpacity: 0.0

    readonly property real dotSizeRatio: 0.09
    readonly property real dotSpacingRatio: 0.2
    readonly property int dotSize: Math.round(fontSize * dotSizeRatio)
    readonly property int dotSpacing: Math.round(fontSize * dotSpacingRatio)

    component DotPair: Column {
        id: pair

        property color dotColor: "white"
        property real dotOpacity: 1.0
        property bool dotVisible: true
        property int dotSize: 1

        Repeater {
            model: 2

            Rectangle {
                width: pair.dotSize
                height: pair.dotSize
                radius: width / 2
                color: pair.dotColor
                opacity: pair.dotOpacity
                visible: pair.dotVisible
            }
        }
    }

    DotPair {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.horizontalNudge
        spacing: root.dotSpacing
        dotSize: root.dotSize
        dotColor: root.mainColor
        dotOpacity: Math.max(root.showGhost ? root.ghostOpacity : 0, root.testOverlayOpacity)
        visible: root.showGhost || root.testOverlayOpacity > 0
    }

    DotPair {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.horizontalNudge
        spacing: root.dotSpacing
        dotSize: root.dotSize
        dotColor: root.mainColor
        dotOpacity: 1 - root.testOverlayOpacity
        dotVisible: root.dotsVisible
    }

    DotPair {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 2 + root.horizontalNudge
        anchors.verticalCenterOffset: 2
        spacing: root.dotSpacing
        dotSize: root.dotSize
        dotColor: root.shadowColor
        dotOpacity: 1 - root.testOverlayOpacity
        dotVisible: root.dotsVisible
        visible: root.showShadow
    }
}
