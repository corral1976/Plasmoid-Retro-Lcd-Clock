// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick

QtObject {
    id: root

    property string family: "DSEG7"

    readonly property string name: {
        if (family === "DotMatrix") {
            return dotMatrixRegular.status === FontLoader.Ready ? dotMatrixRegular.name : "monospace"
        }
        return dseg7Regular.status === FontLoader.Ready ? dseg7Regular.name : "monospace"
    }

    property FontLoader dseg7Regular: FontLoader {
        source: "../assets/DSEG7Classic-Regular.ttf"
    }
    property FontLoader dseg7Bold: FontLoader {
        source: "../assets/DSEG7Classic-Bold.ttf"
    }
    property FontLoader dseg7Italic: FontLoader {
        source: "../assets/DSEG7Classic-Italic.ttf"
    }
    property FontLoader dseg7BoldItalic: FontLoader {
        source: "../assets/DSEG7Classic-BoldItalic.ttf"
    }
    property FontLoader dotMatrixRegular: FontLoader {
        source: "../assets/DotMatrix-Regular.ttf"
    }
    property FontLoader dotMatrixBold: FontLoader {
        source: "../assets/DotMatrix-Bold.ttf"
    }
    property FontLoader dotMatrixItalic: FontLoader {
        source: "../assets/DotMatrix-Italic.ttf"
    }
    property FontLoader dotMatrixBoldItalic: FontLoader {
        source: "../assets/DotMatrix-BoldItalic.ttf"
    }
}
