// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
  id: systemButtons

  spacing: root.font.pointSize

  property var rebootData: ["Reboot", textConstants.reboot, sddm.canReboot]
  property var shutdownData: ["Shutdown", textConstants.shutdown, sddm.canPowerOff]

  Repeater {
    id: buttons

    model: [systemButtons.rebootData, systemButtons.shutdownData]

    RoundButton {
      Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
      Layout.topMargin: root.font.pointSize * 6.5

      palette.buttonText: root.palette.highlight
      display: AbstractButton.TextUnderIcon
      visible: modelData[2]
      hoverEnabled: true

      text: modelData[1]
      font.pointSize: root.font.pointSize * 1.25

      icon.source: Qt.resolvedUrl("Assets/" + modelData[0] + ".svg")
      icon.height: 2 * Math.round((root.font.pointSize * 3) / 2)
      icon.width: 2 * Math.round((root.font.pointSize * 3) / 2)
      icon.color: (hovered || activeFocus) ? root.palette.highlightedText :  root.palette.highlight

      background: Rectangle {
        color: "transparent"
      }

      Keys.onReturnPressed: clicked()
      onClicked: {
        forceActiveFocus()
        index === 0 ? sddm.reboot() : sddm.powerOff()
      }
    }
  }
}
