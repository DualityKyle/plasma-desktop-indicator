/*
    SPDX-FileCopyrightText: 2022 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick 2.0
import QtQuick.Controls 2.5 as QC2
import QtQuick.Layouts 1.12 as QtLayouts
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.plasmoid 2.0

Kirigami.FormLayout {
    id: generalPage

    signal configurationChanged

    property alias cfg_leftClickAction: leftClickAction.currentIndex
    property alias cfg_rightClickAction: rightClickAction.currentIndex

    property alias cfg_scrollWheelOff: scrollWheelOff.checked
    property alias cfg_desktopWrapOn: desktopWrapOn.checked

    QtLayouts.RowLayout {
        Kirigami.FormData.label: i18n("Left click action:")

        QC2.ComboBox {
            id: leftClickAction
            model: [
                i18n("Do nothing"),
                i18n("Switch to next desktop"),
                i18n("Switch to previous desktop"),
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
    
    Component.onCompleted: {
        if (!Plasmoid.configuration.scrollWheelOff) {
            scrollWheelOn.checked = true;
        }
        if (!Plasmoid.configuration.desktopWrapOn) {
            desktopWrapOff.checked = true;
        }
    }
}
