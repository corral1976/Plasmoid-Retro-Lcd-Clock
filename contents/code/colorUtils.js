// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

.pragma library

var PRESETS = {
    "Retro LCD": {
        bg: [0x97 / 255, 0x9f / 255, 0x8b / 255, 0.94],
        text: [20 / 255, 20 / 255, 20 / 255, 1],
        shadow: [100 / 255, 100 / 255, 100 / 255, 0.5],
        border: [20 / 255, 20 / 255, 20 / 255, 1]
    },
    "Neon Green": {
        bg: [0, 0, 0, 1],
        text: [0, 1, 0, 1],
        shadow: [0.2, 0.8, 0.2, 0.6],
        border: [0, 1, 0, 0.5]
    },
    "Vintage Amber": {
        bg: [0, 0, 0, 1],
        text: [1, 0.65, 0, 1],
        shadow: [0.8, 0.5, 0.1, 0.6],
        border: [1, 0.65, 0, 0.5]
    },
    "Sapphire Blue": {
        bg: [0, 0, 0, 1],
        text: [0, 0.5, 1, 1],
        shadow: [0.1, 0.3, 0.7, 0.6],
        border: [0, 0.5, 1, 0.5]
    },
    "Ruby Red": {
        bg: [0, 0, 0, 1],
        text: [1, 0, 0, 1],
        shadow: [0.7, 0.1, 0.1, 0.6],
        border: [1, 0, 0, 0.5]
    },
    "White Led": {
        bg: [0, 0, 0, 1],
        text: [1, 1, 1, 1],
        shadow: [0.6, 0.6, 0.6, 0.6],
        border: [1, 1, 1, 0.5]
    },
    "VFD Teal": {
        bg: [0, 0, 0, 1],
        text: [0, 0.9, 0.75, 1],
        shadow: [0.1, 0.6, 0.5, 0.6],
        border: [0, 0.9, 0.75, 0.5]
    },
    "Nixie Orange": {
        bg: [0, 0, 0, 1],
        text: [1, 0.35, 0, 1],
        shadow: [0.75, 0.25, 0, 0.6],
        border: [1, 0.35, 0, 0.5]
    }
}

function isValidHexColor(hex) {
    return typeof hex === "string" && /^#[0-9a-fA-F]{6}$/.test(hex)
}

function hexToRgb01(hex) {
    var clean = hex.replace("#", "")
    return [
        parseInt(clean.substring(0, 2), 16) / 255,
        parseInt(clean.substring(2, 4), 16) / 255,
        parseInt(clean.substring(4, 6), 16) / 255
    ]
}

function rgbToHex(r, g, b) {
    function toHex(v) {
        var h = Math.round(Math.max(0, Math.min(1, v)) * 255).toString(16)
        return h.length === 1 ? "0" + h : h
    }
    return "#" + toHex(r) + toHex(g) + toHex(b)
}

function getStyleComponents(styleName, customHex) {
    if (styleName === "Custom") {
        var hex = isValidHexColor(customHex) ? customHex : "#00ff00"
        var c = hexToRgb01(hex)
        return {
            bg: [0, 0, 0, 1],
            text: [c[0], c[1], c[2], 1],
            shadow: [c[0], c[1], c[2], 0.6],
            border: [c[0], c[1], c[2], 0.5]
        }
    }
    return PRESETS[styleName] || PRESETS["Neon Green"]
}
