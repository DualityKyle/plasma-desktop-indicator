/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Item {
  id: root

  property var desktop: ({ isCurrent: false })
  property real containerHeight: 0

  readonly property bool isPill: cfg.dotStyle === "pill"
  readonly property int pillSize: root.baseSize

  readonly property var cfg: Plasmoid.configuration
  readonly property real baseSize: {
    switch (cfg.indicatorSizeMode) {
      case "panel": return Math.max(6, containerHeight);
      case "custom": return cfg.indicatorCustomSize;
      default: return Kirigami.Theme.defaultFont.pixelSize;
    }
  }
  readonly property color indicatorCustomColorsOn: cfg.indicatorCustomColorsOn
    ? (desktop.isCurrent ? cfg.activeColor : cfg.inactiveColor)
    : Kirigami.Theme.textColor

  implicitWidth: isPill ? pill.width : unicodeDots.implicitWidth
  implicitHeight: isPill ? pill.height : unicodeDots.implicitHeight

  Text {
    id: unicodeDots

    visible: !root.isPill
    font.pixelSize: root.baseSize
    color: root.indicatorCustomColorsOn
    text: {
      const custom = root.cfg.dotStyle === "custom";
      if (root.desktop.isCurrent)
        return custom ? root.cfg.activeDot : "●";
      return custom ? root.cfg.inactiveDot : "○";
    }
  }

  Rectangle {
    id: pill

    visible: root.isPill
    width: root.desktop.isCurrent ? root.pillSize * 2 : root.pillSize
    height: root.pillSize
    radius: height / 2
    color: root.indicatorCustomColorsOn
    opacity: root.desktop.isCurrent ? 1 : 0.5
  }
}
