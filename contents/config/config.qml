/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.configuration

ConfigModel {
  ConfigCategory {
    name: i18n("General")
    icon: "preferences-desktop-plasma"
    source: "configGeneral.qml"
  }
}
