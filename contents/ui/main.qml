/*
    SPDX-FileCopyrightText: 2012 Luís Gabriel Lima <lampih@gmail.com>
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>
    SPDX-FileCopyrightText: 2016 Eike Hein <hein@kde.org>

    SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents
import org.kde.plasma.private.pager 2.0

GridLayout {
    id: root

    rows: pagerModel.layoutRows
    columns: Math.ceil(pagerModel.count / pagerModel.layoutRows)
    columnSpacing: 0
    rowSpacing: 0

    PagerModel {
        id: pagerModel

        enabled: root.visible
        screenGeometry: plasmoid.screenGeometry

        pagerType: PagerModel.VirtualDesktops
    }

    Repeater {
        id: indicatorRepeater
        model: pagerModel.count

        PlasmaComponents.Label {
            id: inidicatorDot

            text: {
                if (index == pagerModel.currentPage) {
                    return "●";
                } else {
                    return "○";
                }
            }
        }
    }
}