/*
    SPDX-FileCopyrightText: 2022 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.0
import QtQuick.Controls 2.5 as QC2
import QtQuick.Layouts 1.12 as QtLayouts
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Kirigami.FormLayout {
    id: generalPage

    signal configurationChanged

    property alias cfg_leftClickAction: leftClickAction.currentIndex
    property alias cfg_rightClickAction: rightClickAction.currentIndex

    property alias cfg_scrollWheelOff: scrollWheelOff.checked
    property alias cfg_desktopWrapOn: desktopWrapOn.checked
    property alias cfg_singleRow: singleRow.checked

    property alias cfg_dotSize: dotSize.currentIndex
    property alias cfg_dotSizeCustom: dotSizeCustom.value

    QtLayouts.RowLayout {
        Kirigami.FormData.label: i18n("Left click action:")

        QC2.ComboBox {
            id: leftClickAction
            model: [
                i18n("Do nothing"),
                i18n("Switch to next desktop"),
                i18n("Switch to previous desktop"),
                i18n("Go to clicked desktop"),
                i18n("Show desktop overview"),
            ]
            onActivated: cfg_leftClickAction = currentIndex
        }
    }

    QtLayouts.RowLayout {
        Kirigami.FormData.label: i18n("Right click action:")

        QC2.ComboBox {
            id: rightClickAction
            model: [
                i18n("Do nothing"),
                i18n("Switch to next desktop"),
                i18n("Switch to previous desktop"),
                i18n("Show desktop overview"),
            ]
            onActivated: cfg_rightClickAction = currentIndex
            enabled: leftClickAction.currentIndex != 3 
        }
    }
    
    Item {
        Kirigami.FormData.isSection: true
    }

    QtLayouts.ColumnLayout {
        Kirigami.FormData.label: i18n("Scrollwheel action:")
        Kirigami.FormData.buddyFor: scrollWheelOn

        QC2.RadioButton {
            id: scrollWheelOn
            text: i18n("Switch desktops")
        }

        QC2.RadioButton {
            id: scrollWheelOff
            text: i18n("Do nothing")
        }
    }
    
    Item {
        Kirigami.FormData.isSection: true
    }

    QtLayouts.ColumnLayout {
        Kirigami.FormData.label: i18n("Navigation behaviour:")
        Kirigami.FormData.buddyFor: desktopWrapOff

        QC2.RadioButton {
            id: desktopWrapOff
            text: i18n("Standard")
        }

        QC2.RadioButton {
            id: desktopWrapOn
            text: i18n("Wraparound")
        }
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    QtLayouts.ColumnLayout {
        Kirigami.FormData.label: i18n("Desktop Rows:")
        Kirigami.FormData.buddyFor: singleRow

        QC2.RadioButton {
            id: singleRow
            text: i18n("Single row")
        }

        QC2.RadioButton {
            id: multiRow
            text: i18n("Follow Plasma setting")
        }
    }

    Item {
        Kirigami.FormData.isSection: true
    }

    QtLayouts.RowLayout {
        Kirigami.FormData.label: i18n("Indicator Dot Size:")

        QC2.ComboBox {
            id: dotSize
            model: [
                i18n("Default"),
                i18n("Scale with panel size"),
                i18n("Custom Size")
            ]
        }

        QC2.SpinBox {
            id: dotSizeCustom
            textFromValue: function(value) {
                return i18n("%1 px", value)
            }
            valueFromText: function(text) {
                return parseInt(text)
            }
            from: PlasmaCore.Theme.defaultFont.pixelSize
            to: 72
            enabled: dotSize.currentIndex == 2
        }

    }
    
    Component.onCompleted: {
        if (!Plasmoid.configuration.scrollWheelOff) {
            scrollWheelOn.checked = true;
        }
        if (!Plasmoid.configuration.desktopWrapOn) {
            desktopWrapOff.checked = true;
        }
        if (!Plasmoid.configuration.singleRow) {
            multiRow.checked = true;
        }
    }
}
