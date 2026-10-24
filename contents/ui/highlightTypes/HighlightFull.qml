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
  property real fillOpacity: 1

  Rectangle {
    anchors.fill: parent
    visible: root.active
    color: root.color
    opacity: root.fillOpacity
  }
}