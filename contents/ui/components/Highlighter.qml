/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid

Loader {
  id: root

  property bool current: false
  property bool vertical: false
  property string type: cfg.highlightType

  readonly property var cfg: Plasmoid.configuration

  readonly property var highlightTypes: ({
    "line": "../highlightTypes/highlightLine.qml",
    "circle": "../highlightTypes/highlightCircle.qml"
  })

  readonly property real lineInset: type === "line" ? 3: 0
  readonly property real contentOffset: 
    (Plasmoid.location === PlasmaCore.Types.TopEdge || Plasmoid.location === PlasmaCore.Types.LeftEdge) 
      ? -lineInset / 2 
      : lineInset / 2

  anchors.fill: parent
  active: type !== "none"
  source: highlightTypes[type] ?? ""

  Binding { target: root.item; property: "active"; value: root.current }
  Binding { target: root.item; property: "vertical"; value: root.vertical }
}