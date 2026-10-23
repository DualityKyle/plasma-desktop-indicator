/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import "../components"

Item {
  id: root

  property var desktop: ({ isCurrent: false })
  property bool vertical: false
  property real panelThickness: 0

  readonly property bool isPill: cfg.minimalStyle === "pill"
  readonly property int pillSize: root.baseSize

  readonly property var cfg: Plasmoid.configuration
  readonly property real baseSize: {
    switch (cfg.minimalSizeMode) {
      case "panel": return Math.max(6, panelThickness);
      case "custom": return cfg.minimalSizeCustom;
      default: return Kirigami.Theme.defaultFont.pixelSize;
    }
  }
  readonly property color indicatorCustomColor: cfg.indicatorCustomColors
    ? (desktop.isCurrent ? cfg.indicatorColorActive : cfg.indicatorColorInactive)
    : Kirigami.Theme.textColor

  implicitWidth: isPill ? pill.width : minimalText.implicitWidth
  implicitHeight: isPill ? pill.height : minimalText.implicitHeight

  RotatableText {
    id: minimalText

    visible: !root.isPill
    vertical: root.vertical
    font.pixelSize: root.baseSize
    color: root.indicatorCustomColor

    onColorChanged: {
      if (color !== root.indicatorCustomColor) {
        color = Qt.binding(() => root.indicatorCustomColor);
      }
    }

    Connections {
      target: root.cfg

      function onColorChange() {
        minimalText.color = Qt.binding(() => root.indicatorCustomColor);
      }
    }

    text: {
      const custom = root.cfg.minimalStyle === "custom";
      if (root.desktop.isCurrent)
        return custom ? root.cfg.minimalCharActive : "●";
      return custom ? root.cfg.minimalCharInactive : "○";
    }
  }

  Rectangle {
    id: pill

    visible: root.isPill
    width: root.vertical ? root.pillSize : (root.desktop.isCurrent ? root.pillSize * 2 : root.pillSize)
    height: root.vertical ? (root.desktop.isCurrent ? root.pillSize * 2 : root.pillSize) : root.pillSize
    radius: Math.min(width, height) / 2
    color: root.indicatorCustomColor
    opacity: root.desktop.isCurrent ? 1 : 0.5
  }
}
