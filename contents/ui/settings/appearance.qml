/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QC
import org.kde.kquickcontrols as KQuickControls
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
  property alias cfg_indicatorSpacing: indicatorSpacing.value
  property alias cfg_rotateText: rotateText.checked
  property string cfg_dotStyle
  property alias cfg_activeDot: activeDot.text
  property alias cfg_inactiveDot: inactiveDot.text
  property string cfg_indicatorSizeMode
  property alias cfg_indicatorCustomSize: indicatorCustomSize.value
  property alias cfg_indicatorCustomColorsOn: indicatorCustomColorsOn.checked
  property alias cfg_activeColor: activeColorButton.color
  property alias cfg_inactiveColor: inactiveColorButton.color

  ColumnLayout {

    Kirigami.FormLayout {
      Layout.fillWidth: true

      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Layout Options")
      }
      RowLayout {
        Kirigami.FormData.label: i18n("Indicator spacing:")
        QC.Slider {
          id: indicatorSpacing
          Layout.minimumWidth: Kirigami.Units.gridUnit * 15
          from: 0
          to: 20
          stepSize: 1
        }
        QC.Label {
          id: valueLabel
          Layout.minimumWidth: valueMetrics.width
          horizontalAlignment: Text.AlignRight
          text: i18n("%1px", indicatorSpacing.value)

          TextMetrics {
            id: valueMetrics
            font: valueLabel.font
            text: i18n("%1px", indicatorSpacing.to)
          }
        }
      }
      QC.CheckBox {
        id: rotateText
        text: i18n("Rotate text on vertical panels")
      }
      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Indicator Types")
      }
      QC.ComboBox {
        Kirigami.FormData.label: i18n("Dot type:")
        textRole: "text"
        valueRole: "value"
        model: [
          {
            text: i18n("Default"),
            value: "default"
          },
          {
            text: i18n("GNOME-style pills"),
            value: "pill"
          },
          {
            text: i18n("Custom"),
            value: "custom"
          }
        ]
        Component.onCompleted: currentIndex = indexOfValue(cfg_dotStyle)
        onActivated: cfg_dotStyle = currentValue
      }

      QC.TextField {
        id: activeDot
        Kirigami.FormData.label: i18n("Active Dot:")
        Layout.maximumWidth: 35
        maximumLength: 1
        visible: cfg_dotStyle === "custom"
      }
      QC.TextField {
        id: inactiveDot
        Kirigami.FormData.label: i18n("Inactive Dot:")
        Layout.maximumWidth: 35
        maximumLength: 1
        visible: cfg_dotStyle === "custom"
      }
      RowLayout {
        Kirigami.FormData.label: i18n("Indicator size:")
        QC.ComboBox {
          textRole: "text"
          valueRole: "value"
          model: [
            {
              text: i18n("Default theme size"),
              value: "theme"
            },
            {
              text: i18n("Scale with panel"),
              value: "panel"
            },
            {
              text: i18n("Custom"),
              value: "custom"
            }
          ]
          Component.onCompleted: currentIndex = indexOfValue(cfg_indicatorSizeMode)
          onActivated: cfg_indicatorSizeMode = currentValue
        }
        QC.SpinBox {
          id: indicatorCustomSize
          Kirigami.FormData.label: i18n("Custom size (px):")
          from: 4
          to: 72
          visible: cfg_indicatorSizeMode === "custom"
        }
      }
      Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: i18n("Colour Options")
      }
      QC.CheckBox {
        id: indicatorCustomColorsOn
        Kirigami.FormData.label: i18n("Colours:")
        text: i18n("Customise colours")
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.maximumWidth: Kirigami.Units.gridUnit * 16
      Layout.alignment: Qt.AlignHCenter
      visible: indicatorCustomColorsOn.checked
      spacing: Kirigami.Units.largeSpacing

      ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        Layout.maximumWidth: Number.POSITIVE_INFINITY
        spacing: Kirigami.Units.smallSpacing

        QC.Label {
          Layout.alignment: Qt.AlignHCenter
          text: i18n("Current desktop")
        }
        KQuickControls.ColorButton {
          id: activeColorButton
          Layout.alignment: Qt.AlignHCenter
          showAlphaChannel: false
        }
        QC.Label {
          Layout.alignment: Qt.AlignHCenter
          text: activeColorButton.color.toString().toUpperCase()
        }
      }
      ColumnLayout {
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        Layout.maximumWidth: Number.POSITIVE_INFINITY
        spacing: Kirigami.Units.smallSpacing

        QC.Label {
          Layout.alignment: Qt.AlignHCenter
          text: i18n("Inactive desktop")
        }
        KQuickControls.ColorButton {
          id: inactiveColorButton
          Layout.alignment: Qt.AlignHCenter
          showAlphaChannel: false
        }
        QC.Label {
          Layout.alignment: Qt.AlignHCenter
          text: inactiveColorButton.color.toString().toUpperCase()
        }
      }
    }
  }
}
