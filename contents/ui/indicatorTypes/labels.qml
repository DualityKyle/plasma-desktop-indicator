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

  property var desktop: ({ isCurrent: false, index: 0, number: 1, name: "" })
  property bool vertical: false
  property bool hovered: false
  property bool occupied: false
  property real panelThickness: 0
  readonly property var cfg: Plasmoid.configuration

  readonly property string labelText: {
    const number = String(desktop.number);
    const name = desktop.name || number;

    switch (cfg.labelType) {
      case "name":
        return name;
      case "template":
        return (cfg.labelTypeTemplate || "%n")
          .replace(/%n/g, number)
          .replace(/%d/g, () => name);
      case "list":
        return (cfg.labelTypeList ?? [])[desktop.index] || "Extra";
      default:
        return number;
    }
  }

  readonly property bool textRotated: labelText.rotated
  readonly property real verticalCellHeight: Kirigami.Units.gridUnit * 2
  readonly property real cellLength: vertical && !textRotated ? verticalCellHeight : fitsText ? textLength : cfg.labelWidth

  readonly property real activeTextSize: sizeFor(cfg.labelActiveSize)
  readonly property real inactiveTextSize: sizeFor(cfg.labelSize)

  readonly property bool fitsText: cfg.labelSizeType === "scale"
  readonly property real textLength: Math.ceil(labelMetrics.advanceWidth) + Kirigami.Units.smallSpacing * 2

  function sizeFor(customSize) {
    switch (cfg.labelSizeType) {
      case "scale": return Math.max(6, Math.round(panelThickness * 0.4));
      case "custom": return customSize;
      default: return Kirigami.Theme.defaultFont.pixelSize;
    }
  }

  implicitWidth: vertical ? panelThickness : cellLength
  implicitHeight: vertical ? cellLength : panelThickness

  readonly property real realThickness: panelThickness - labelHighlighter.lineInset
  readonly property real maxLineLength: vertical && !textRotated ? realThickness : cellLength
  readonly property real lineStackSpace: vertical && !textRotated ? cellLength : realThickness

  Highlighter {
    id: labelHighlighter

    current: root.desktop.isCurrent
    vertical: root.vertical
    hovered: root.hovered
    occupied: root.occupied
  }

  TextMetrics {
    id: labelMetrics
    font.pixelSize: Math.max(root.activeTextSize, root.inactiveTextSize)
    font.bold: root.cfg.labelActiveBold || root.cfg.labelBold
    font.italic: root.cfg.labelActiveItalic || root.cfg.labelItalic
    text: root.labelText
  }

  RotatableText {
    id: labelText
    vertical: root.vertical
    anchors.centerIn: parent

    color: {
      if (!root.cfg.indicatorCustomColors)
        return Kirigami.Theme.textColor;
      return root.desktop.isCurrent ? root.cfg.indicatorColorActive : root.cfg.indicatorColorInactive
    }
    font.pixelSize: root.desktop.isCurrent ? root.activeTextSize : root.inactiveTextSize
    font.bold: root.desktop.isCurrent ? root.cfg.labelActiveBold : root.cfg.labelBold
    font.italic: root.desktop.isCurrent ? root.cfg.labelActiveItalic : root.cfg.labelItalic
    text: root.labelText

    wrapText: root.cfg.labelWrap
    maxLength: root.maxLineLength
    maxHeight: root.lineStackSpace
    horizontalAlignment: Text.AlignHCenter
  }
}