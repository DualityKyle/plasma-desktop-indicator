/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PC3

Item {
  id: root

  property bool vertical: false
  property alias font: label.font
  property alias color: label.color
  property alias text: label.text
  property alias horizontalAlignment: label.horizontalAlignment
  property alias elide: label.elide
  property real maxLength: -1
  property real maxHeight: -1

  readonly property var cfg: Plasmoid.configuration
  readonly property real angle: {
    if (!vertical) {
      return 0
    }
    switch (cfg.textRotation) {
      case "edge":
        return Plasmoid.location === PlasmaCore.Types.LeftEdge ? -90 : 90
      case "90":
        return 90
      case "270":
        return 270
      default:
        return 0
    }
  }
  readonly property bool rotated: angle !== 0
  readonly property bool limited: maxLength > 0

  implicitWidth:  rotated ? label.height : label.width
  implicitHeight: rotated ? label.width : label.height

  PC3.Label {
    id: label
    anchors.centerIn: parent
    rotation: root.angle

    width: root.limited ? root.maxLength : implicitWidth
    height: root.limited && root.maxHeight > 0 ? root.maxHeight : implicitHeight
    verticalAlignment: Text.AlignVCenter
    wrapMode: root.limited ? Text.WordWrap : Text.NoWrap
    elide: root.limited ? Text.ElideRight : Text.ElideNone
  }
}
