/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.kirigami as Kirigami

Item {
  id: root

  property bool active: false
  property bool vertical: false
  property color color: Kirigami.Theme.highlightColor

  HighlightFull {
    anchors.fill: parent
    active: root.active
    vertical: root.vertical
    color: root.color
    fillOpacity: 0.65
  }

  HighlightLine {
    anchors.fill: parent
    active: root.active
    vertical: root.vertical
    color: root.color
  }
}