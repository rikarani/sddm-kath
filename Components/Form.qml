// Config created by Keyitdev https://github.com/Keyitdev/sddm-astronaut-theme
// Copyright (C) 2022-2025 Keyitdev
// Based on https://github.com/MarianArlt/sddm-sugar-dark
// Distributed under the GPLv3+ License https://www.gnu.org/licenses/gpl-3.0.html

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Column {
  id: input

  property bool failed

  Item {
    id: errorMessageField

    width: parent.width / 2
    height: root.font.pointSize * 2
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      id: errorMessage

      width: parent.width
      horizontalAlignment: Text.AlignHCenter
      text: input.failed ? `${textConstants.loginFailed}` : keyboard.capsLock ? textConstants.capslockWarning : null
      font.pointSize: root.font.pointSize * 1.25
      font.italic: true
      color: root.palette.highlight
      opacity: 0

      states: [
        State {
          name: "fail"
          when: input.failed
          PropertyChanges { errorMessage.opacity: 1}
        },
        State {
          name: "capslock"
          when: keyboard.capsLock
          PropertyChanges { errorMessage.opacity: 1}
        }
      ]
      transitions: [
        Transition {
          PropertyAnimation { properties: "opacity"; duration: 100 }
        }
      ]
    }
  }

  Item {
    id: usernameField

    width: parent.width / 2
    height: root.font.pointSize * 4.5
    anchors.horizontalCenter: parent.horizontalCenter

    ComboBox {
      id: selectUser

      width: parent.height
      height: parent.height
      anchors.left: parent.left
      z: 2

      model: userModel
      currentIndex: model.lastIndex
      textRole: "name"
      hoverEnabled: true
      onActivated: {
        username.text = currentText
      }

      Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Down && !popup.opened) {
          username.forceActiveFocus();
        }
        if ((event.key === Qt.Key_Up || event.key === Qt.Key_Left) && !popup.opened) {
          popup.open();
        }
      }

      KeyNavigation.down: username
      KeyNavigation.right: username

      delegate: ItemDelegate {
        width: usernamePopup.width - 20
        anchors.horizontalCenter: usernamePopup.horizontalCenter

        contentItem: Text {
          verticalAlignment: Text.AlignVCenter
          horizontalAlignment: Text.AlignHCenter
          text: model.name
          font.pointSize: root.font.pointSize * 1.25
          font.capitalization: Font.AllLowercase
          font.family: root.font.family
          color: root.palette.highlightedText
        }

        background: Rectangle {
          color: selectUser.highlightedIndex === index ? root.palette.highlight : "transparent"
          radius: 5
        }
      }

      indicator: Button {
        id: usernameIcon

        width: selectUser.height * 1
        height: parent.height
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        icon.height: parent.height * 0.25
        icon.width: parent.height * 0.25
        enabled: false
        icon.color: root.palette.highlight
        icon.source: Qt.resolvedUrl("../Assets/User.svg")

        background: Rectangle { color: "transparent" }
      }

      background: Rectangle { color: "transparent" }

      popup: Popup {
        id: usernamePopup

        width: usernameField.width
        implicitHeight: contentItem.implicitHeight
        x: 0
        y: parent.height - username.height / 3
        padding: 10

        contentItem: ListView {
          implicitHeight: contentHeight + 20
          clip: true
          model: selectUser.popup.visible ? selectUser.delegateModel : null
          currentIndex: selectUser.highlightedIndex
          ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
          radius: 10
          color: "#90b4ff"
          layer.enabled: true
        }

        enter: Transition {
          NumberAnimation { property: "opacity"; from: 0; to: 1 }
        }
      }

      states: [
        State {
          name: "focused"
          when: selectUser.activeFocus
          PropertyChanges { usernameIcon.icon.color: root.palette.buttonText }
        }
      ]

      transitions: [
        Transition {
          PropertyAnimation { properties: "icon.color"; duration: 150 }
        }
      ]
    }

    TextField {
      id: username

      anchors.centerIn: parent
      width: parent.width
      height: root.font.pointSize * 3
      horizontalAlignment: TextInput.AlignHCenter
      z: 1

      text: selectUser.currentText
      color: root.palette.highlight
      font.bold: true
      font.capitalization: Font.AllLowercase
      placeholderText: textConstants.userName
      placeholderTextColor: "#bbbbbb"
      selectByMouse: true
      renderType: Text.QtRendering
      onFocusChanged: {
        if (focus) selectAll()
      }

      background: Rectangle {
        color: "#111111"
        opacity: 0.2
        radius: 20
        border.width: parent.activeFocus ? 2 : 1
        border.color: "transparent"
      }

      onAccepted: sddm.login(username.text.toLowerCase(), password.text.toLowerCase(), sessionButton.selectedSession)
      KeyNavigation.down: passwordIcon
    }
  }

  Item {
    id: passwordField
    width: parent.width / 2
    height: root.font.pointSize * 4.5
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
      id: passwordIcon
      width: selectUser.height * 1
      height: parent.height
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      z: 2

      icon.height: parent.height * 0.25
      icon.width: parent.height * 0.25
      icon.color: root.palette.highlight
      icon.source: checked ? Qt.resolvedUrl("../Assets/Password.svg") : Qt.resolvedUrl("../Assets/Password2.svg")
      checkable: true

      background: Rectangle {
        color: "transparent"
      }

      states: [
        State {
          name: "focused"
          when: passwordIcon.activeFocus || passwordIcon.hovered
          PropertyChanges {
            passwordIcon.icon.color: root.palette.buttonText
          }
        }
      ]

      onClicked: toggle()
      Keys.onReturnPressed: toggle()
      Keys.onEnterPressed: toggle()
      KeyNavigation.down: password
    }

    TextField {
      id: password

      width: parent.width
      height: root.font.pointSize * 3
      anchors.centerIn: parent
      horizontalAlignment: TextInput.AlignHCenter

      font.bold: true
      color: root.palette.highlight
      focus: true
      echoMode: passwordIcon.checked ? TextInput.Normal : TextInput.Password
      placeholderText: textConstants.password
      placeholderTextColor: "#bbbbbb"
      passwordCharacter: "•"
      renderType: Text.QtRendering
      selectByMouse: true

      background: Rectangle {
        color: "#111111"
        opacity: 0.2
        radius: 20
        border.width: parent.activeFocus ? 2 : 1
        border.color: "transparent"
      }

      onAccepted: sddm.login(username.text.toLowerCase(), password.text.toLowerCase(), sessionButton.selectedSession)
      KeyNavigation.down: loginButton
    }
  }

  Item {
    id: login

    width: parent.width / 2
    height: root.font.pointSize * 4.5
    anchors.horizontalCenter: parent.horizontalCenter

    Button {
      id: loginButton

      height: root.font.pointSize * 3
      implicitWidth: parent.width
      anchors.centerIn: parent

      text: textConstants.login
      enabled: username.text !== "" && password.text !== ""
      hoverEnabled: true

      contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pointSize: root.font.pointSize
        font.family: root.font.family
        color: root.palette.highlightedText
        text: parent.text
        opacity: parent.enabled ? 1 : 0.5
      }

      background: Rectangle {
        id: buttonBackground

        color: root.palette.highlight
        opacity: parent.enabled ? 0.9: 0.2
        radius: 20
      }

      onClicked: sddm.login(username.text.toLowerCase(), password.text.toLowerCase(), sessionButton.selectedSession)
      Keys.onReturnPressed: clicked()
      Keys.onEnterPressed: clicked()
      KeyNavigation.down: systemButtons.children[0]
    }
  }

  Connections {
    target: sddm
    function onLoginSucceeded() {}
    function onLoginFailed() {
      input.failed = true
      resetError.restart()
    }
  }

  Timer {
    id: resetError

    interval: 2000
    onTriggered: input.failed = false
  }
}
