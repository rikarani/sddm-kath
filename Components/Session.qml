import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  implicitWidth: parent.width / 2
  Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
  Layout.preferredHeight: root.height / 18
  Layout.maximumHeight: root.height / 18

  property var selectedSession: selectSession.currentIndex

  ComboBox {
    id: selectSession

    height: root.font.pointSize * 2
    anchors.horizontalCenter: parent.horizontalCenter
    hoverEnabled: true

    model: sessionModel
    currentIndex: sessionModel.lastIndex
    textRole: "name"

    Keys.onPressed: (event) => {
      if((event.key === Qt.Key_Left || event.key === Qt.Key_Right) && !popup.visible) {
        popup.open()
      }
    }

    background: Rectangle {
      color: "transparent"
    }

    indicator: Item {
      visible: false
    }

    contentItem: Text {
      id: displayedItem

      verticalAlignment: Text.AlignVCenter
      text: `Session is ${selectSession.currentText}`
      color: root.palette.highlight
      font.pointSize: root.font.pointSize
      font.family: root.font.family
      Keys.onReleased: selectSession.popup.open()
    }

    popup: Popup {
      id: sessionPopup

      width: sessionButton.width
      implicitHeight: contentItem.implicitHeight
      x: -sessionPopup.width / 2 + displayedItem.width / 2
      y: parent.height - 1
      padding: 10

      contentItem: ListView {
        implicitHeight: contentHeight + 20
        clip: true
        model: selectSession.popup.visible ? selectSession.delegateModel : null
        currentIndex: selectSession.highlightedIndex
        ScrollIndicator.vertical: ScrollIndicator {}
      }

      background: Rectangle {
        radius: 10
        color: "#90b4ff"
        border.color: root.palette.highlight
        border.width: 1
      }

      enter: Transition {
        NumberAnimation {
          property: "opacity"
          from: 0
          to: 1
        }
      }
    }

    delegate: ItemDelegate {
      width: sessionPopup.width - 20
      anchors.horizontalCenter: sessionPopup.horizontalCenter

      contentItem: Text {
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: model.name
        font.pointSize: root.font.pointSize * 0.8
        font.family: root.font.family
        color: root.palette.highlightedText
      }

      background: Rectangle {
        color: selectSession.highlightedIndex === index ? root.palette.highlight : "transparent"
        radius: 5
      }
    }
  }
}
