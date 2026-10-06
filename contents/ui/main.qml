/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.taskmanager as TaskManager
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
  id: root

  preferredRepresentation: fullRepresentation

  readonly property var cfg: Plasmoid.configuration
  readonly property var indicatorType: ({
    "dot": "indicatorTypes/dots.qml"
  })

  TaskManager.VirtualDesktopInfo { id: desktopInfo }
  DesktopHandlers { id: actions; info: desktopInfo; cfg: root.cfg; }

  fullRepresentation: GridLayout {
    rows: cfg.singleRow
      ? 1
      : desktopInfo.desktopLayoutRows;
    columns: cfg.singleRow
      ? desktopInfo.numberOfDesktops
      : Math.ceil(desktopInfo.numberOfDesktops / desktopInfo.desktopLayoutRows);
    columnSpacing: 0
    rowSpacing: 0

    WheelHandler {
      enabled: root.cfg.scrollWheelOn
      orientation: Qt.Vertical
      acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
      onWheel: (event) => {
        const scrollDir = event.angleDelta;
        if (!root.cfg.scrollHorizontal || Math.abs(scrollDir.y) >= Math.abs(scrollDir.x))
        actions.handleWheel(scrollDir.y);
      }
    }

    WheelHandler {
      enabled: root.cfg.scrollWheelOn && root.cfg.horizontalScroll
      orientation: Qt.Horizontal
      acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
      onWheel: (event) => {
        const scrollDir = event.angleDelta;
        if (Math.abs(scrollDir.x) > Math.abs(scrollDir.y))
          actions.handleWheel(scrollDir.x);
      }
    }

    Repeater {
      model: desktopInfo.numberOfDesktops

      Rectangle {
        id: indicator

        color: "transparent"
        implicitWidth: indicatorContent.implicitWidth + (cfg.indicatorSpacing * 2)
        Layout.minimumHeight: 0
        Layout.fillHeight: true

        Loader {
          id: indicatorContent

          anchors.centerIn: parent
          source: root.indicatorType[root.cfg.indicatorType] ?? root.indicatorType["dot"]

          Binding {
            target: indicatorContent.item
            property: "desktop"
            value: { "isCurrent": index === actions.currentIndex }
          }
          Binding {
            target: indicatorContent.item
            property: "containerHeight"
            value: indicator.height
          }
        }

        TapHandler {
          acceptedButtons: Qt.LeftButton
          enabled: root.cfg.leftClickAction !== "none"
          onTapped: actions.runAction(root.cfg.leftClickAction, index)
        }
        TapHandler {
          acceptedButtons: Qt.RightButton
          enabled: root.cfg.rightClickAction !== "none"
          onTapped: actions.runAction(root.cfg.rightClickAction, index)
        }
      }
    }
  }

  Plasmoid.contextualActions: [
    PlasmaCore.Action {
      text: i18n("Add Virtual Desktop")
      icon.name: "list-add"
      onTriggered: actions.addDesktop()
    },
    PlasmaCore.Action {
      text: i18n("Remove Virtual Desktop")
      icon.name: "list-remove"
      onTriggered: actions.removeDesktop()
    },
    PlasmaCore.Action {
      text: i18n("Configure Virtual Desktops...")
      icon.name: "configure"
      onTriggered: actions.configureDesktops()
    }
  ]
}
