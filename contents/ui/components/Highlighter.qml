/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami

Loader {
  id: root

  property bool current: false
  property bool vertical: false
  property bool hovered: false
  property string type: cfg.highlightType

  readonly property var cfg: Plasmoid.configuration

  readonly property var highlightTypes: ({
    "line": "../highlightTypes/HighlightLine.qml",
    "circle": "../highlightTypes/HighlightCircle.qml",
    "full": "../highlightTypes/HighlightFull.qml",
    "fullLine": "../highlightTypes/HighlightFullLine.qml"
  })

  readonly property color highlightColor: cfg.highlightCustomColors ? cfg.highlightColor : Kirigami.Theme.highlightColor
  readonly property real lineInset: type === "line" ? 3: 0
  readonly property real contentOffset: 
    (Plasmoid.location === PlasmaCore.Types.TopEdge || Plasmoid.location === PlasmaCore.Types.LeftEdge) 
      ? -lineInset / 2 
      : lineInset / 2

  anchors.fill: parent
  active: type !== "none"
  source: highlightTypes[type] ?? ""

  opacity: current ? 1 : 0.25

  Binding { target: root.item; property: "active"; value: root.current || root.hovered }
  Binding { target: root.item; property: "vertical"; value: root.vertical }
  Binding { target: root.item; property: "color"; value: root.highlightColor }
}