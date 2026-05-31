// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Column {
  id: clock

  property int pointSize: 0

  Label {
    id: time

    anchors.horizontalCenter: parent.horizontalCenter
    font.pointSize: clock.pointSize * 9.25
    font.bold: true
    color: "#b4d8ff"
    renderType: Text.QtRendering

    function updateTime() {
      text = new Date().toLocaleTimeString(Qt.locale("id-ID"), "HH:mm:ss")
    }
  }

  Label {
    id: date

    anchors.horizontalCenter: parent.horizontalCenter
    font.pointSize: clock.pointSize * 3.25
    font.bold: true
    color: "#b4d8ff"
    renderType: Text.QtRendering

    function updateDate() {
      text = new Date().toLocaleDateString(Qt.locale("id-ID"), "dddd, dd MMMM yyyy")
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      time.updateTime()
      date.updateDate()
    }
  }

  Component.onCompleted: {
    time.updateTime()
    date.updateDate()
  }
}
