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

  property var desktop: ({ isCurrent: false, number: 1, name: "" })
  property bool vertical: false
  property real panelThickness: 0

  readonly property var cfg: Plasmoid.configuration

  readonly property string labelString: {
    if (cfg.labelType === "name" && desktop.name !== "")
      return desktop.name;
    return String(desktop.number);
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

  readonly property real maxLineLength: textRotated ? implicitHeight : implicitWidth
  readonly property real lineStackSpace: textRotated ? implicitWidth : implicitHeight

  Highlighter {
    current: root.desktop.isCurrent
    vertical: root.vertical
  }

  Loader {
    id: highlight

    anchors.fill: parent
    active: root.cfg.highlightType !== "none"
    source: root.highlightTypes[root.cfg.highlightType] ?? ""

    Binding { target: highlight.item; property: "active"; value: root.desktop.isCurrent }
    Binding { target: highlight.item; property: "vertical"; value: root.vertical }
  }

  TextMetrics {
    id: labelMetrics
    font.pixelSize: Math.max(root.activeTextSize, root.inactiveTextSize)
    font.bold: root.cfg.labelActiveBold || root.cfg.labelBold
    font.italic: root.cfg.labelActiveItalic || root.cfg.labelItalic
    text: root.labelString
  }

  RotatableText {
    id: labelText
    vertical: root.vertical
    anchors.centerIn: parent

    color: Kirigami.Theme.textColor
    font.pixelSize: root.desktop.isCurrent ? root.activeTextSize : root.inactiveTextSize
    font.bold: root.desktop.isCurrent ? root.cfg.labelActiveBold : root.cfg.labelBold
    font.italic: root.desktop.isCurrent ? root.cfg.labelActiveItalic : root.cfg.labelItalic
    text: root.labelString

    wrapText: root.cfg.labelWrap
    maxLength: root.maxLineLength
    maxHeight: root.lineStackSpace
    horizontalAlignment: Text.AlignHCenter
  }
}