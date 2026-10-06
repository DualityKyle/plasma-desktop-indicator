/*
    SPDX-FileCopyrightText: 2022-2026 Kyle McGrath <dualitykyle@pm.me>

    SPDX-License-Identifier: GPL-3.0-or-later
*/

import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as PlasmaSupport

Item {
  id: handlers

  required property var info
  required property var cfg

  readonly property int currentIndex: info.desktopIds.indexOf(info.currentDesktop)
  readonly property int count: info.numberOfDesktops

  property real wheelDelta: 0

  /* org.kde.taskmanager's requestActivate method is not Q_INVOKABLE
     so instead we call KWin directly to select virtual desktops */
  function activateDesktopAt(index) {
    const desktopId = info.desktopIds[index];

    if (!desktopId) {
      return;
    }

    executable.exec(
      "gdbus call --session "
      + "--dest org.kde.KWin "
      + "--object-path /VirtualDesktopManager "
      + "--method org.freedesktop.DBus.Properties.Set "
      + "org.kde.KWin.VirtualDesktopManager "
      + "current "
      + "\"<'" + desktopId + "'>\""
    );
  }

  function addDesktop() {
    executable.exec(
      "gdbus call --session "
      + "--dest org.kde.KWin "
      + "--object-path /VirtualDesktopManager "
      + "--method org.kde.KWin.VirtualDesktopManager.createDesktop "
      + count + " \"Desktop " + (count + 1) + "\""
    );
  }

  function removeDesktop() {
    if (count <= 1) {
      return;
    }
    executable.exec(
      "gdbus call --session "
      + "--dest org.kde.KWin "
      + "--object-path /VirtualDesktopManager "
      + "--method org.kde.KWin.VirtualDesktopManager.removeDesktop "
      + "\"'" + info.desktopIds[count - 1] + "'\""
    );
  }

  function configureDesktops() {
    executable.exec("kcmshell6 kcm_kwin_virtualdesktops");
  }

  function exposeDesktop() {
    executable.exec('qdbus org.kde.kglobalaccel /component/kwin invokeShortcut Overview');
  }

  function stepDesktop(delta) {
    const target = currentIndex + delta;
    if (target >= 0 && target < count)
      activateDesktopAt(target);
    else if (cfg.desktopWrapOn)
      activateDesktopAt((target + count) % count);
  }

  function runAction(name, clickedIndex) {
    switch (name) {
    case "next":      stepDesktop(1); break;
    case "previous":  stepDesktop(-1); break;
    case "goto":      activateDesktopAt(clickedIndex); break;
    case "overview":  exposeDesktop(); break;
    }
  }

  function handleWheel(delta) {
    wheelDelta += cfg.invertScroll ? -delta : delta;
    while (Math.abs(wheelDelta) >= 120) {
      const down = wheelDelta < 0;
      wheelDelta += down ? 120 : -120;
      stepDesktop(down ? 1 : -1);
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
}