// SPDX-FileCopyrightText: 2026 Carlos Corral
// SPDX-License-Identifier: GPL-3.0-or-later

import QtQuick
import org.kde.plasma.plasma5support as P5Support

P5Support.DataSource {
    id: root

    signal tick(date now)

    engine: "time"
    connectedSources: ["Local"]
    interval: 1000
    intervalAlignment: P5Support.Types.NoAlignment

    onDataChanged: {
        var local = data["Local"]
        if (local) {
            tick(local["DateTime"])
        }
    }
}
