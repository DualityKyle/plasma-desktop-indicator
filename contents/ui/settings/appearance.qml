/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QC
import org.kde.kquickcontrols as KQuickControls
import org.kde.plasma.components as PC3
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami
import org.kde.taskmanager as TaskManager
import org.kde.iconthemes as KIconThemes

KCM.SimpleKCM {
  id: appearancePage

  property string cfg_indicatorType
  property int cfg_indicatorSpacing
  property string cfg_textRotation
  property string cfg_minimalStyle
  property alias cfg_minimalCharActive: minimalCharActive.text
  property alias cfg_minimalCharInactive: minimalCharInactive.text
  property string cfg_minimalSizeMode
  property alias cfg_minimalSizeCustom: minimalSizeCustom.value

  property alias cfg_labelWidth: labelWidth.value
  property string cfg_labelType
  property string cfg_highlightType

  property string cfg_labelSizeType
  property alias cfg_labelActiveSize: labelActiveSize.value
  property alias cfg_labelSize: labelSize.value  
  property alias cfg_labelActiveBold: labelActiveBold.checked
  property alias cfg_labelBold: labelBold.checked
  property alias cfg_labelActiveItalic: labelActiveItalic.checked
  property alias cfg_labelItalic: labelItalic.checked
  property alias cfg_labelWrap: labelWrap.checked

  property var cfg_iconNames: []
  property var cfg_iconNamesDefault
  property string cfg_iconColorMode

  property alias cfg_labelTypeTemplate: labelTypeTemplate.text
  property var cfg_labelTypeList: []
  property var cfg_labelTypeListDefault

  property int pickingIndex: -1

  function entryAt(list, i) {
    return (list ?? [])[i] ?? "";
  }

  function setEntry(list, i, value) {
    const entries = (list ?? []).slice();
    while (entries.length <= i)
      entries.push("");
    
    entries[i] = value;

    return entries;
  }

  function iconAt(i) { return entryAt(cfg_iconNames, i); }
  function setIconName(i, name) { cfg_iconNames = setEntry(cfg_iconNames, i, name); }

  function labelAt(i) { return entryAt(cfg_labelTypeList, i); }
  function setLabelName(i, name) { cfg_labelTypeList = setEntry(cfg_labelTypeList, i, name); }

  TaskManager.VirtualDesktopInfo { id: desktopInfo }

  KIconThemes.IconDialog {
    id: iconDialog
    onIconNameChanged: {
      if (appearancePage.pickingIndex >= 0 && iconName)
        appearancePage.setIconName(appearancePage.pickingIndex, iconName);
    }
  }  

  Kirigami.FormLayout {
    Layout.fillWidth: true
    
    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Layout Options")
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Indicator type:")
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Minimal"), value: "minimal" },
        { text: i18n("Labels"), value: "label" },
        { text: i18n("Icons"), value: "icon" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_indicatorType)
      onActivated: cfg_indicatorType = currentValue
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Indicator spacing:")
      PC3.Slider {
        id: indicatorSpacing
        Layout.preferredWidth: Kirigami.Units.gridUnit * 8
        from: 0
        to: 20
        value: cfg_indicatorSpacing
        onMoved: cfg_indicatorSpacing = Math.round(value)
      }
      QC.Label {
        id: valueLabel
        Layout.minimumWidth: valueMetrics.width
        horizontalAlignment: Text.AlignRight
        text: i18n("%1px", cfg_indicatorSpacing)

        TextMetrics {
          id: valueMetrics
          font: valueLabel.font
          text: i18n("%1px", cfg_indicatorSpacing)
        }
      }
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Rotate text on vertical panels:")
      textRole: "text"
      valueRole: "value"
      model: [
        {
          text: i18n("None"),
          value: "none"
        },
        {
          text: i18n("Follow screen edge"),
          value: "edge"
        },
        {
          text: i18n("90° clockwise"),
          value: "90"
        },
        {
          text: i18n("270° clockwise"),
          value: "270"
        }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_textRotation)
      onActivated: cfg_textRotation = currentValue
      enabled: cfg_indicatorType === "label" || cfg_minimalStyle !== "pill"
    }

    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Minimal Indicator Options")
      visible: cfg_indicatorType === "minimal"
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Style:")
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
          text: i18n("Custom characters"),
          value: "custom"
        }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_minimalStyle)
      onActivated: cfg_minimalStyle = currentValue
      visible: cfg_indicatorType === "minimal"
    }

    GridLayout {
      visible: cfg_indicatorType === "minimal" && cfg_minimalStyle === "custom"
      columns: 2
      columnSpacing: Kirigami.Units.smallSpacing
      rowSpacing: Kirigami.Units.smallSpacing

      QC.Label {
        text: i18n("Active")
      }
      QC.TextField {
        id: minimalCharActive
        Layout.preferredWidth: Kirigami.Units.gridUnit * 2
        horizontalAlignment: TextInput.AlignHCenter
        maximumLength: 1
      }

      QC.Label {
        text: i18n("Inactive")
      }
      QC.TextField {
        id: minimalCharInactive
        Layout.preferredWidth: Kirigami.Units.gridUnit * 2
        horizontalAlignment: TextInput.AlignHCenter
        maximumLength: 1
      }
    }

    RowLayout {
      visible: cfg_indicatorType === "minimal"
      
      Kirigami.FormData.label: i18n("Size:")
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
        Component.onCompleted: currentIndex = indexOfValue(cfg_minimalSizeMode)
        onActivated: cfg_minimalSizeMode = currentValue
      }
      PC3.SpinBox {
        id: minimalSizeCustom
        from: 4
        to: 72
        textFromValue: value => i18n("%1px", value)
        valueFromText: text => parseInt(text)
        visible: cfg_minimalSizeMode === "custom"
      }
    }

    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Label Options")
      visible: cfg_indicatorType === "label"
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Indicator width:")
      visible: cfg_indicatorType === "label"
      
      PC3.Slider {
        id: labelWidth
        Layout.minimumWidth: Kirigami.Units.gridUnit * 8
        from: 20
        to: 160
        stepSize: 1
      }
      QC.Label {
        id: widthLabel
        Layout.minimumWidth: widthMetrics.width
        horizontalAlignment: Text.AlignRight
        text: i18n("%1px", labelWidth.value)

        TextMetrics {
          id: widthMetrics
          font: widthLabel.font
          text: i18n("%1px", labelWidth.to)
        }
      }
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Label shows:")
      visible: cfg_indicatorType === "label"
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Desktop number"), value: "number" },
        { text: i18n("Desktop name"), value: "name" },
        { text: i18n("Template"), value: "template" },
        { text: i18n("Defined list"), value: "list" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_labelType)
      onActivated: cfg_labelType = currentValue
    }
    QC.TextField {
      id: labelTypeTemplate
      Kirigami.FormData.label: i18n("Template:")
      visible: cfg_indicatorType === "label" && cfg_labelType === "template"
      placeholderText: "D%n"
      QC.ToolTip.text: i18n("%n = desktop number, %d = desktop name")
      QC.ToolTip.visible: hovered || activeFocus
      QC.ToolTip.delay: Kirigami.Units.toolTipDelay
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Highlight:")
      visible: cfg_indicatorType === "label"
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Line"), value: "line" },
        { text: i18n("Circle"), value: "circle" },
        { text: i18n("Full"), value: "full" },
        { text: i18n("Full + line"), value: "fullLine" },
        { text: i18n("None"), value: "none" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_highlightType)
      onActivated: cfg_highlightType = currentValue
    }
    QC.Button {
      visible: cfg_indicatorType === "label" && cfg_labelType === "list"
      text: i18n("Restore default labels")
      icon.name: "edit-undo"
      onClicked: appearancePage.cfg_labelTypeList = (appearancePage.cfg_labelTypeListDefault ?? []).slice()
    }
    Repeater {
      model: desktopInfo.numberOfDesktops

      QC.TextField {
        Kirigami.FormData.label: i18n("%1:", desktopInfo.desktopNames[index] || i18n("Desktop %1", index + 1))
        visible: cfg_indicatorType === "label" && cfg_labelType === "list"
        Layout.preferredWidth: Kirigami.Units.gridUnit * 12
        placeholderText: "Extra"
        text: appearancePage.entryAt(appearancePage.cfg_labelTypeList, index)
        onEditingFinished: {
          appearancePage.cfg_labelTypeList = appearancePage.withEntry(appearancePage.cfg_labelTypeList, index, text.trim());
          text = Qt.binding(() => appearancePage.entryAt(appearancePage.cfg_labelTypeList, index));
        }
      }
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Text size:")
      visible: cfg_indicatorType === "label"
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
            value: "scale"
          },
          {
            text: i18n("Custom"),
            value: "custom"
          }
        ]
        Component.onCompleted: currentIndex = indexOfValue(cfg_labelSizeType)
        onActivated: cfg_labelSizeType = currentValue
      }
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Current desktop text:")
      visible: cfg_indicatorType === "label"
      QC.ToolButton {
        id: labelActiveBold
        icon.name: "format-text-bold"
        display: QC.AbstractButton.IconOnly
        checkable: true
        QC.ToolTip.text: i18n("Bold")
        QC.ToolTip.visible: hovered
        QC.ToolTip.delay: Kirigami.Units.toolTipDelay
      }
      QC.ToolButton {
        id: labelActiveItalic
        icon.name: "format-text-italic"
        display: QC.AbstractButton.IconOnly
        checkable: true
        QC.ToolTip.text: i18n("Italic")
        QC.ToolTip.visible: hovered
        QC.ToolTip.delay: Kirigami.Units.toolTipDelay
      }
      PC3.SpinBox {
        id: labelActiveSize
        from: 4
        to: 72
        visible: cfg_labelSizeType === "custom"
      }      
    }
    RowLayout {
      Kirigami.FormData.label: i18n("Other desktops' text:")
      visible: cfg_indicatorType === "label"
      QC.ToolButton {
        id: labelBold
        icon.name: "format-text-bold"
        display: QC.AbstractButton.IconOnly
        checkable: true
        QC.ToolTip.text: i18n("Bold")
        QC.ToolTip.visible: hovered
        QC.ToolTip.delay: Kirigami.Units.toolTipDelay
      }
      QC.ToolButton {
        id: labelItalic
        icon.name: "format-text-italic"
        display: QC.AbstractButton.IconOnly
        checkable: true
        QC.ToolTip.text: i18n("Italic")
        QC.ToolTip.visible: hovered
        QC.ToolTip.delay: Kirigami.Units.toolTipDelay
      }
      PC3.SpinBox {
        id: labelSize
        from: 4
        to: 72
        visible: cfg_labelSizeType === "custom"
      }      
    }
    QC.CheckBox {
      id: labelWrap
      Kirigami.FormData.label: i18n("Wrap text:")
    }

    Kirigami.Separator {
      Kirigami.FormData.isSection: true
      Kirigami.FormData.label: i18n("Icon Options")
      visible: cfg_indicatorType === "icon"
    }
    QC.ComboBox {
      Kirigami.FormData.label: i18n("Icon colours:")
      textRole: "text"
      valueRole: "value"
      model: [
        { text: i18n("Original"), value: "original" },
        { text: i18n("Original, greyscale when inactive"), value: "greyInactive" },
        { text: i18n("Greyscale"), value: "greyscale" },
        { text: i18n("Custom colours"), value: "custom" }
      ]
      Component.onCompleted: currentIndex = indexOfValue(cfg_iconColorMode)
      onActivated: cfg_iconColorMode = currentValue
    } 
    QC.Button {
      text: i18n("Restore default icons")
      icon.name: "edit-undo"
      onClicked: appearancePage.cfg_iconNames = (appearancePage.cfg_iconNamesDefault ?? []).slice()
    }
    Repeater {
      model: desktopInfo.numberOfDesktops

      RowLayout {
        Kirigami.FormData.label: i18n("%1:", desktopInfo.desktopNames[index] || i18n("Desktop %1", index + 1))
        visible: cfg_indicatorType === "icon"

        QC.Button {
          icon.name: appearancePage.iconAt(index) || "desktop"
          display: QC.AbstractButton.IconOnly
          QC.ToolTip.text: i18n("Choose icon…")
          QC.ToolTip.visible: hovered
          QC.ToolTip.delay: Kirigami.Units.toolTipDelay
          onClicked: {
            appearancePage.pickingIndex = index;
            iconDialog.open();
          }
        }
        QC.TextField {
          Layout.preferredWidth: Kirigami.Units.gridUnit * 12
          placeholderText: i18n("Icon name or file path")
          text: appearancePage.iconAt(index)
          onEditingFinished: {
            appearancePage.setIconName(index, text.trim());
            text = Qt.binding(() => appearancePage.iconAt(index));
          }
        }
        QC.ToolButton {
          icon.name: "edit-clear"
          display: QC.AbstractButton.IconOnly
          visible: appearancePage.iconAt(index) !== ""
          QC.ToolTip.text: i18n("Reset to default")
          QC.ToolTip.visible: hovered
          onClicked: appearancePage.setIconName(index, "")
        }
      }
    }
  }
}
