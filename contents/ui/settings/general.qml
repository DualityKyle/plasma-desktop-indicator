/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Controls as QC
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
  property string cfg_leftClickAction
  property string cfg_rightClickAction
  property alias cfg_scrollWheelOn: scrollWheelOn.checked
  property alias cfg_desktopWrapOn: desktopWrapOn.checked
  property alias cfg_singleRow: singleRow.checked

  Kirigami.FormLayout {
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Left click action:")
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Do nothing"), value: "none" },
        { text: i18n("Switch to next desktop"), value: "next" },
        { text: i18n("Switch to previous desktop"), value: "previous" },
        { text: i18n("Go to clicked desktop"), value: "goto" },
        { text: i18n("Show desktop overview"), value: "overview" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_leftClickAction)
      onActivated: cfg_leftClickAction = currentValue
    }

    QC.ComboBox {
      Kirigami.FormData.label: i18n("Right click action:")
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Do nothing"), value: "none" },
        { text: i18n("Switch to next desktop"), value: "next" },
        { text: i18n("Switch to previous desktop"), value: "previous" },
        { text: i18n("Go to clicked desktop"), value: "goto" },
        { text: i18n("Show desktop overview"), value: "overview" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_rightClickAction)
      onActivated: cfg_rightClickAction = currentValue
    }

    QC.CheckBox {
      id: scrollWheelOn
      Kirigami.FormData.label: i18n("Scrolling:")
      text: i18n("Switch desktops with the mouse wheel")
    }

    Column {
      Kirigami.FormData.label: i18n("Navigation behaviour:")
      Kirigami.FormData.buddyFor: desktopWrapOn

      QC.RadioButton {
        id: desktopWrapOn
        text: i18n("Wraparound")
      }
      QC.RadioButton {
        id: followWraparoundSetting
        text: i18n("Follow Plasma setting")
        checked: !desktopWrapOn.checked
      }
    }

    Column {
      Kirigami.FormData.label: i18n("Desktop Rows:")
      Kirigami.FormData.buddyFor: singleRow

      QC.RadioButton {
        id: singleRow
        text: i18n("Use a single row")
      }
      QC.RadioButton {
        id: followRowLayout
        text: i18n("Follow Plasma setting")
        checked: !singleRow.checked
      }
    }
  }
}
