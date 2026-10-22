/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PC3
import "rotation.js" as Rotation

Item {
  id: root

  property bool vertical: false
  property alias font: label.font
  property alias color: label.color
  property string text: ""
  property alias horizontalAlignment: label.horizontalAlignment
  property real maxLength: -1
  property real maxHeight: -1
  property bool wrapText: false

  readonly property var cfg: Plasmoid.configuration
  readonly property bool hasMaxLength: maxLength > 0
  readonly property real angle: Rotation.angleFor(vertical, cfg.textRotation, Plasmoid.location === PlasmaCore.Types.LeftEdge)
  readonly property bool rotated: angle !== 0

  implicitWidth:  rotated ? label.height : label.width
  implicitHeight: rotated ? label.width : label.height

  function fitText(text, width, maxLines) {
    const labelText = text.trim();

    if (width <= 0 || labelText === "")
      return "";

    if (metrics.advanceWidth(labelText) <= width)
      return labelText;

    const words = labelText.split(/\s+/);
    const lines = [];
    let i = 0;

    while (i < words.length && lines.length < maxLines) {
      if (lines.length === maxLines - 1) {
        lines.push(metrics.elidedText(
          words.slice(i).join(" "), Qt.ElideLeft, width
        ));
        break;
      }

      let line = words[i++];

      if (metrics.advanceWidth(line) > width) {
        lines.push(metrics.elidedText(line, Qt.ElideRight, width));
        continue;
      }

      while (i < words.length) {
        const candidate = line + " " + words[i];

        if (metrics.advanceWidth(candidate) > width)
          break;
        
        line = candidate;
        i++;
      }
      lines.push(line);
    }
    return lines.join("\n");
  }

  FontMetrics {
    id: metrics
    font: label.font
  }

  PC3.Label {
    id: label
    anchors.centerIn: parent
    rotation: root.angle

    width: root.hasMaxLength ? root.maxLength : implicitWidth
    height: root.maxHeight > 0 ? root.maxHeight : implicitHeight

    text: {
      if (!root.hasMaxLength)
        return root.text;
      
      void metrics.font;

      const maxLines = root.wrapText && root.maxHeight > 0
        ? Math.max(1, Math.floor(root.maxHeight / Math.max(1, metrics.lineSpacing)))
        : 1;

      return root.fitText(root.text, root.maxLength, maxLines);
    }

    verticalAlignment: Text.AlignVCenter
    wrapMode: Text.NoWrap
    elide: Text.ElideNone
  }
}
