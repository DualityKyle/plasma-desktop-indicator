/*
    SPDX-FileCopyrightText: 2022 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as PlasmaSupport
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager

PlasmoidItem {
  id: root

  property int scrollWheelDelta: 0

  readonly property int currentDesktopIndex: desktopInfo.desktopIds.indexOf(desktopInfo.currentDesktop)

  TaskManager.VirtualDesktopInfo {
    id: desktopInfo
  }

  preferredRepresentation: fullRepresentation

  fullRepresentation: GridLayout {
    rows: {
      if (Plasmoid.configuration.singleRow) {
        return 1;
      } else {
        return desktopInfo.desktopLayoutRows;
      }
    }
    columns: {
      if (Plasmoid.configuration.singleRow) {
        return desktopInfo.numberOfDesktops;
      } else {
        return Math.ceil(desktopInfo.numberOfDesktops / desktopInfo.desktopLayoutRows);
      }
    }
    columnSpacing: 0
    rowSpacing: 0

    Repeater {
      id: indicatorRepeater
      model: desktopInfo.numberOfDesktops

      Rectangle {
        id: indicatorContainer

        color: "transparent"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumWidth: {
          if (Plasmoid.configuration.dotSize == 0) {
            return Kirigami.Theme.defaultFont.pixelSize;
          } else if (Plasmoid.configuration.dotSize == 1) {
            return indicatorDot.font.pixelSize;
          } else {
            return Plasmoid.configuration.dotSizeCustom;
          }
        }
        Layout.minimumHeight: {
          if (!Plasmoid.configuration.dotSize == 2) {
            return 0;
          } else {
            return Plasmoid.configuration.dotSizeCustom;
          }
        }

        MouseArea {
          anchors.fill: parent
          acceptedButtons: {
            if (Plasmoid.configuration.rightClickAction == 0) {
              return Qt.LeftButton;
            } else {
              return Qt.LeftButton | Qt.RightButton;
            }
          }
          z: {
            if (Plasmoid.configuration.leftClickAction != 3) {
              return 1;
            } else {
              return 0;
            }
          }

          // TODO: Clean up and refactor this horrible, horrible mess
          onClicked: mouse => {
            if (mouse.button === Qt.LeftButton && (Plasmoid.configuration.leftClickAction != 0 || Plasmoid.configuration.leftClickAction != 3)) {
              if (Plasmoid.configuration.leftClickAction == 1) {
                if (root.currentDesktopIndex < desktopInfo.numberOfDesktops - 1) {
                  desktopInfo.changePage(root.currentDesktopIndex + 1);
                } else if (Plasmoid.configuration.desktopWrapOn) {
                  desktopInfo.changePage(0);
                }
              } else if (Plasmoid.configuration.leftClickAction == 2) {
                if (root.currentDesktopIndex > 0) {
                  desktopInfo.changePage(root.currentDesktopIndex - 1);
                } else if (Plasmoid.configuration.desktopWrapOn) {
                  desktopInfo.changePage(desktopInfo.numberOfDesktops - 1);
                }
              } else if (Plasmoid.configuration.leftClickAction == 4) {
                exposeDesktop();
              }
            } else if (mouse.button === Qt.RightButton && (Plasmoid.configuration.rightClickAction != 0 || Plasmoid.configuration.leftClickAction != 3)) {
              if (Plasmoid.configuration.rightClickAction == 1) {
                if (root.currentDesktopIndex < desktopInfo.numberOfDesktops - 1) {
                  desktopInfo.changePage(root.currentDesktopIndex + 1);
                } else if (Plasmoid.configuration.desktopWrapOn) {
                  desktopInfo.changePage(0);
                }
              } else if (Plasmoid.configuration.rightClickAction == 2) {
                if (root.currentDesktopIndex > 0) {
                  desktopInfo.changePage(root.currentDesktopIndex - 1);
                } else if (Plasmoid.configuration.desktopWrapOn) {
                  desktopInfo.changePage(desktopInfo.numberOfDesktops - 1);
                }
              } else if (Plasmoid.configuration.rightClickAction == 3) {
                exposeDesktop();
              }
            }
          }

          // TODO: Clean up and refactor this not-quite-as-horrible mess
          onWheel: wheel => {
            if (Plasmoid.configuration.scrollWheelOn) {
              // TODO: Add user option to invert direction of y-axis scroll
              scrollWheelDelta += wheel.angleDelta.x || wheel.angleDelta.y;

              let wheelStep = 0;

              while (scrollWheelDelta <= 120) {
                scrollWheelDelta += 120;
                wheelStep--;
              }

              while (scrollWheelDelta >= 120) {
                scrollWheelDelta -= 120;
                wheelStep++;
              }

              while (wheelStep !== 0) {
                if (wheelStep < 0) {
                  if (root.currentDesktopIndex < desktopInfo.numberOfDesktops - 1) {
                    desktopInfo.changePage(root.currentDesktopIndex + 1);
                  } else if (Plasmoid.configuration.desktopWrapOn) {
                    desktopInfo.changePage(0);
                  }
                } else {
                  if (root.currentDesktopIndex > 0) {
                    desktopInfo.changePage(root.currentDesktopIndex - 1);
                  } else if (Plasmoid.configuration.desktopWrapOn) {
                    desktopInfo.changePage(desktopInfo.numberOfDesktops - 1);
                  }
                }
                wheelStep += (wheelStep < 0) ? 1 : -1;
              }
            }
          }
        }

        PlasmaComponents.Label {
          id: indicatorDot

          anchors.centerIn: parent
          font.pixelSize: {
            if (Plasmoid.configuration.dotSize == 0) {
              return Kirigami.Theme.defaultFont.pixelSize;
            } else if (Plasmoid.configuration.dotSize == 1) {
              //TODO: Consider adding state support for vertical panel users
              return parent.height;
            } else {
              return Plasmoid.configuration.dotSizeCustom;
            }
          }
          text: {
            if (Plasmoid.configuration.dotType == 0) {
              if (index == root.currentDesktopIndex) {
                return "●";
              } else {
                return "○";
              }
            } else {
              if (index == root.currentDesktopIndex) {
                return Plasmoid.configuration.activeDot;
              } else {
                return Plasmoid.configuration.inactiveDot;
              }
            }
          }
          MouseArea {
            anchors.fill: parent
            onClicked: mouse => {
              if (Plasmoid.configuration.leftClickAction == 3) {
                desktopInfo.changePage(index);
              }
            }
            z: {
              if (Plasmoid.configuration.leftClickAction != 3) {
                return 0;
              } else {
                return 1;
              }
            }
          }
        }
      }
    }
  }

  PlasmaSupport.DataSource {
    id: executable
    engine: "executable"
    connectedSources: []
    onNewData: sourceName => disconnectSource(sourceName)

    function exec(cmd) {
      executable.connectSource(cmd);
    }
  }

  function exposeDesktop() {
    executable.exec('qdbus org.kde.kglobalaccel /component/kwin invokeShortcut Overview');
  }
}
