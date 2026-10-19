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

  implicitWidth: textRotated ? labelText.implicitWidth : cfg.labelWidth
  implicitHeight: textRotated ? cfg.labelWidth : labelText.implicitHeight

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
    color: Kirigami.Theme.textColor
    text: {
      if (root.cfg.labelType === "name" && root.desktop.name !== "")
        return root.desktop.name;
      return String(root.desktop.number);
    }
  }
}