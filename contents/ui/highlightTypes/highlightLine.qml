/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

Item {
  id: root

  property bool active: false
  property bool vertical: false
  property color color: Kirigami.Theme.highlightColor
  readonly property int thickness: 3
  
  // Distance from label edge to cell edge 
  readonly property real edgeGap: Math.max(0, Math.round((panelThickness - (vertical ? width : height)) / 2))
  readonly property string lineSide: {
    switch (Plasmoid.location) {
      case PlasmaCore.Types.TopEdge:   return "bottom"
      case PlasmaCore.Types.LeftEdge:  return "right"
      case PlasmaCore.Types.RightEdge: return "left"
      default: return "top"
    }
  }

  Rectangle {
    visible: root.active

    color: root.color

    width: root.vertical ? root.thickness : root.width
    height: root.vertical ? root.height : root.thickness
    x: root.lineSide === "right" ? root.width - width : 0
    y: root.lineSide === "bottom" ? root.height - height : 0
  }
}