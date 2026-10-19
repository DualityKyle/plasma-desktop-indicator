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
  property real containerSize: 0

  Rectangle {
    visible: root.active
    anchors.centerIn: parent
    color: Kirigami.Theme.highlightColor

    readonly property real wanted: Math.min(root.width, root.height) + Kirigami.Units.smallSpacing * 2
    width: root.containerSize > 0 ? Math.min(wanted, root.containerSize) : wanted
    height: width
    radius: width / 2
  }
}