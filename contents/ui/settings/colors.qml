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
  property alias cfg_indicatorCustomColors: indicatorCustomColors.checked
  property alias cfg_indicatorColorActive: indicatorColorActiveButton.color
  property alias cfg_indicatorColorInactive: indicatorColorInactiveButton.color
  property alias cfg_highlightCustomColors: highlightCustomColors.checked
  property alias cfg_highlightColor: highlightColorButton.color
  property alias cfg_highlightOccupiedColor: highlightOccupiedColorButton.color
  property alias cfg_highlightOccupiedSynced: highlightOccupiedSynced.checked

  Kirigami.FormLayout {
    QC.Switch {
      id: indicatorCustomColors
      Kirigami.FormData.label: i18n("Colours:")
      text: i18n("Customise indicator colours")
    }
    QC.Switch {
      id: highlightCustomColors
      Kirigami.FormData.label: i18n("Colours:")
      text: i18n("Customise highlight colours")
    }

    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Text / Labels")
      enabled: indicatorCustomColors.checked
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Active desktop:")
      enabled: indicatorCustomColors.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: indicatorColorActiveButton
        showAlphaChannel: false
      }
      QC.Label {
        text: indicatorColorActiveButton.color.toString().toUpperCase()
      }
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Inactive desktop:")
      enabled: indicatorCustomColors.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: indicatorColorInactiveButton
        showAlphaChannel: false
      }
      QC.Label {
        text: indicatorColorInactiveButton.color.toString().toUpperCase()
      }
    }
    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Highlights")
      enabled: highlightCustomColors.checked
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Active desktop:")
      enabled: highlightCustomColors.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: highlightColorButton
        showAlphaChannel: false
      }
      QC.Label {
        text: highlightColorButton.color.toString().toUpperCase()
      }
    }
    QC.CheckBox {
      id: highlightOccupiedSynced
      Kirigami.FormData.label: i18n("Desktops with windows:")
      text: i18n("Use highlight colour")
      enabled: highlightCustomColors.checked
    }
    RowLayout {
      enabled: highlightCustomColors.checked && !highlightOccupiedSynced.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: highlightOccupiedColorButton
        showAlphaChannel: false
      }
      QC.Label {
        text: highlightOccupiedColorButton.color.toString().toUpperCase()
      }
    }
  }
}