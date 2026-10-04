/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PC3
import org.kde.kirigami as Kirigami

Item {
  id: root

  property var desktop: ({ isCurrent: false })
  property real containerHeight: 0

  readonly property var cfg: Plasmoid.configuration
  readonly property real baseSize: {
    switch (cfg.indicatorSizeMode) {
      case "panel": return Math.max(6, containerHeight);
      case "custom": return cfg.indicatorCustomSize;
      default: return Kirigami.Theme.defaultFont.pixelSize;
    }
  }

  implicitWidth: unicodeDots.implicitWidth
  implicitHeight: unicodeDots.implicitHeight

  PC3.Label {
    id: unicodeDots

    font.pixelSize: root.baseSize
    text: {
      const custom = root.cfg.dotStyle === "custom";
      if (root.desktop.isCurrent)
        return custom ? root.cfg.activeDot : "●";
      return custom ? root.cfg.inactiveDot : "○";
    }
  }
}
