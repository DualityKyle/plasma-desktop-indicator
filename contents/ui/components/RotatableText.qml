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
  property real maxLength: -1

  readonly property var cfg: Plasmoid.configuration
  readonly property bool rotated: vertical && cfg.rotateText

  implicitWidth:  rotated ? label.implicitHeight : label.implicitWidth
  implicitHeight: rotated ? label.implicitWidth  : label.implicitHeight

  PC3.Label {
    id: label
    anchors.centerIn: parent
    width: root.maxLength > 0 ? Math.min(implicitWidth, root.maxLength) : implicitWidth
    rotation: !root.rotated ? 0
            : (Plasmoid.location === PlasmaCore.Types.LeftEdge ? -90 : 90)
  }
}
