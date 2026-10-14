// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

Item {
    id: root

    property int size: 8
    property bool enabled: false
    property bool active: false
    property bool blinkState: true
    property bool snoozing: false
    property color mainColor: "white"
    property color shadowColor: "black"
    property bool showShadow: true
    property bool showGhost: false
    property real ghostOpacity: 0.12
    property real testOverlayOpacity: 0.0

    readonly property color dotColor: {
        if (!root.enabled) {
            return "transparent"
        } else if (root.active) {
            return root.blinkState ? root.mainColor : Qt.rgba(1, 1, 1, 0.3)
        } else if (root.snoozing) {
            return Qt.rgba(root.mainColor.r, root.mainColor.g, root.mainColor.b, 0.5)
        }
        return root.mainColor
    }
    readonly property color shadowDotColor: {
        if (!root.enabled) {
            return "transparent"
        } else if (root.active) {
            return root.blinkState ? root.shadowColor : Qt.rgba(1, 1, 1, 0.3)
        } else if (root.snoozing) {
            return Qt.rgba(root.shadowColor.r, root.shadowColor.g, root.shadowColor.b, 0.5)
        }
        return root.shadowColor
    }

    width: size
    height: size
    visible: enabled || showGhost || testOverlayOpacity > 0

    Rectangle {
        width: root.size
        height: root.size
        radius: root.size / 2
        color: root.mainColor
        opacity: Math.max(root.showGhost ? root.ghostOpacity : 0, root.testOverlayOpacity)
        visible: root.showGhost || root.testOverlayOpacity > 0
    }

    Rectangle {
        width: root.size
        height: root.size
        radius: root.size / 2
        color: root.dotColor
        opacity: 1 - root.testOverlayOpacity
    }

    Rectangle {
        x: Math.max(1, Math.round(root.size / 4))
        y: Math.max(1, Math.round(root.size / 4))
        width: root.size
        height: root.size
        radius: root.size / 2
        color: root.shadowDotColor
        visible: root.showShadow
        opacity: 1 - root.testOverlayOpacity
    }
}
