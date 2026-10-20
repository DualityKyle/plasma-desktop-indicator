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
  property real containerSize: 0

  readonly property var cfg: Plasmoid.configuration
  readonly property var highlightTypes: ({
    "line": "../highlightTypes/highlightLine.qml",
    "circle": "../highlightTypes/highlightCircle.qml"
  })
  readonly property bool textRotated: labelText.rotated
  readonly property real activeTextSize: sizeFor(cfg.labelActiveSize)
  readonly property real inactiveTextSize: sizeFor(cfg.labelSize)

  function sizeFor(customSize) {
    switch (cfg.labelSizeType) {
      case "scale": return Math.max(6, Math.round(containerSize * 0.5));
      case "custom": return customSize;
      default: return Kirigami.Theme.defaultFont.pixelSize;
    }
  }

  implicitWidth: textRotated ? sizeMetrics.height : cfg.labelWidth
  implicitHeight: textRotated ? cfg.labelWidth : sizeMetrics.height

  FontMetrics {
    id: sizeMetrics
    font.pixelSize: Math.max(root.activeTextSize, root.inactiveTextSize)
  }

  Loader {
    id: highlight

    anchors.fill: parent
    active: root.cfg.highlightType !== "none"
    source: root.highlightTypes[root.cfg.highlightType] ?? ""

    Binding { target: highlight.item; property: "active"; value: root.desktop.isCurrent }
    Binding { target: highlight.item; property: "vertical"; value: root.vertical }
    Binding { target: highlight.item; property: "containerSize"; value: root.containerSize }
  }

  RotatableText {
    id: labelText

    anchors.centerIn: parent
    vertical: root.vertical
    maxLength: root.cfg.labelWidth
    elide: Text.ElideLeft
    color: Kirigami.Theme.textColor
    font.pixelSize: root.desktop.isCurrent ? root.activeTextSize : root.inactiveTextSize
    font.bold: root.desktop.isCurrent ? root.cfg.labelActiveBold : root.cfg.labelBold
    font.italic: root.desktop.isCurrent ? root.cfg.labelActiveItalic : root.cfg.labelItalic
    text: {
      if (root.cfg.labelType === "name" && root.desktop.name !== "")
        return root.desktop.name;
      return String(root.desktop.number);
    }
  }
}