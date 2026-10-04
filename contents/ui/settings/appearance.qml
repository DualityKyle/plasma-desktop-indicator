/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QC
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
  property string cfg_dotStyle
  property alias cfg_activeDot: activeDot.text
  property alias cfg_inactiveDot: inactiveDot.text
  property string cfg_indicatorSizeMode
  property alias cfg_indicatorCustomSize: indicatorCustomSize.value

  Kirigami.FormLayout {
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
  }
}
