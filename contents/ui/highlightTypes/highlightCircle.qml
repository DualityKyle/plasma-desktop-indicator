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

  Rectangle {
    visible: root.active
    anchors.centerIn: parent

    color: Kirigami.Theme.highlightColor
    width: Math.min(Kirigami.Units.gridUnit * 1.5, root.width, root.height)
    height: width
    radius: width / 2
  }
}