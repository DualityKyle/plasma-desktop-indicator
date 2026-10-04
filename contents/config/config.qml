/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import org.kde.plasma.configuration

ConfigModel {
  ConfigCategory {
    name: i18n("General")
    icon: "preferences-desktop-plasma"
    source: "settings/general.qml"
  }
  ConfigCategory {
    name: i18n("Appearance")
    icon: "preferences-desktop-theme"
    source: "settings/appearance.qml"
  }
}
