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
  property alias cfg_minimalCustomColors: minimalCustomColors.checked
  property alias cfg_minimalColorActive: minimalColorActiveButton.color
  property alias cfg_minimalColorInactive: minimalColorInactiveButton.color

  Kirigami.FormLayout {
    QC.Switch {
      id: minimalCustomColors
      Kirigami.FormData.label: i18n("Colours:")
      text: i18n("Customise colours")
    }

    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Text / Labels")
      enabled: minimalCustomColors.checked
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Active desktop:")
      enabled: minimalCustomColors.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: minimalColorActiveButton
        showAlphaChannel: false
      }
      QC.Label {
        text: minimalColorActiveButton.color.toString().toUpperCase()
      }
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Inactive desktop:")
      enabled: minimalCustomColors.checked
      spacing: Kirigami.Units.largeSpacing

      KQuickControls.ColorButton {
        id: minimalColorInactiveButton
        showAlphaChannel: false
      }
      QC.Label {
        text: minimalColorInactiveButton.color.toString().toUpperCase()
      }
    }
  }
}