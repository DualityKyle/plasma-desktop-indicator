/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Effects
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import "../components"
import "../components/rotation.js" as Rotation

Item {
  id: root

  property var desktop: ({ isCurrent: false, index: 0 })
  property bool vertical: false
  property real panelThickness: 0
  readonly property var cfg: Plasmoid.configuration

  readonly property string iconName: (cfg.iconNames ?? [])[desktop.index] || "desktop"

  readonly property real angle: Rotation.angleFor(vertical, cfg.textRotation, Plasmoid.location === PlasmaCore.Types.LeftEdge)
  readonly property bool iconRotated: angle !== 0

  readonly property real iconScale: 1
  readonly property real iconSize: Math.max(8, panelThickness)
  readonly property real iconLength: iconSize + Kirigami.Units.smallSpacing * 2

  readonly property string colorMode: cfg.iconColorMode
  readonly property bool tinted: colorMode === "custom"
  readonly property bool greyscale: colorMode === "greyscale" || (colorMode === "greyInactive" && !desktop.isCurrent)
  readonly property color iconColor: desktop.isCurrent ? cfg.indicatorColorActive : cfg.indicatorColorInactive

  readonly property real verticalCellHeight: Kirigami.Units.gridUnit * 2
  readonly property real cellLength: {
    if (vertical && !iconRotated) 
      return Math.max(verticalCellHeight, iconLength);
    return Math.max(cfg.labelWidth, iconLength);
  }

  implicitWidth: vertical ? panelThickness : cellLength
  implicitHeight: vertical ? cellLength : panelThickness

  Highlighter {
    id: iconHighlighter

    current: root.desktop.isCurrent
    vertical: root.vertical
  }

  Kirigami.Icon {
    readonly property real size: Math.min(root.iconSize, root.panelThickness - iconHighlighter.lineInset)

    anchors.centerIn: parent
    anchors.horizontalCenterOffset: root.vertical ? iconHighlighter.contentOffset : 0
    anchors.verticalCenterOffset: root.vertical ? 0 : iconHighlighter.contentOffset    
    
    width: size
    height: size
    rotation: root.angle

    source: root.iconName
    fallback: "desktop"

    isMask: root.tinted
    color: root.tinted ? root.iconColor : "transparent"


    layer.enabled: root.colorMode === "greyscale" || root.colorMode === "greyInactive"
    layer.effect: MultiEffect {
      saturation: root.greyscale ? -1.0 : 0

      Behavior on saturation {
        NumberAnimation { duration: Kirigami.Units.shortDuration }
      }
    }
  }
}