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

  readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
  readonly property var cfg: Plasmoid.configuration
  readonly property var indicatorType: ({
    "dot": "indicatorTypes/dots.qml",
    "menu": "indicatorTypes/menu.qml",
    "label": "indicatorTypes/labels.qml",
    "position": "indicatorTypes/position.qml"
  })

  TaskManager.VirtualDesktopInfo { id: desktopInfo }
  DesktopHandlers { id: actions; info: desktopInfo; cfg: root.cfg; }

  fullRepresentation: GridLayout {
    readonly property int layoutRows: Math.max(1, cfg.singleRow ? 1 : desktopInfo.desktopLayoutRows)
    readonly property int layoutCols: Math.max(desktopInfo.numberOfDesktops / layoutRows)

    flow: root.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
    rows: root.vertical ? layoutCols : layoutRows
    columns: root.vertical ? layoutRows : layoutCols
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
        
        implicitWidth:  root.vertical ? 0 : indicatorContent.implicitWidth  + (cfg.indicatorSpacing * 2)
        implicitHeight: root.vertical ? indicatorContent.implicitHeight + (cfg.indicatorSpacing * 2) : 0
        Layout.minimumWidth:0
        Layout.minimumHeight: 0
        Layout.fillWidth: root.vertical
        Layout.fillHeight: !root.vertical

        Loader {
          id: indicatorContent

          anchors.centerIn: parent
          source: root.indicatorType[root.cfg.indicatorType] ?? root.indicatorType["dot"]

          Binding {
            target: indicatorContent.item
            property: "desktop"
            value: ({
              "index": index,
              "number": index + 1,
              "name": desktopInfo.desktopNames[index] ?? "",
              "isCurrent": index === actions.currentIndex
            })
          }

          Binding {
            target: indicatorContent.item
            property: "vertical"
            value: root.vertical
          }

          Binding {
            target: indicatorContent.item
            property: "containerSize"
            value: root.vertical ? indicator.width : indicator.height
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
