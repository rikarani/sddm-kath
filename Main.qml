pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtMultimedia

import SddmComponents as SDDM

import "Components"

Pane {
    id: root

    width: 1920
    height: 1080
    padding: 0

    palette.window: "#242455"
    palette.highlight: "#b4d8ff"
    palette.highlightedText: "#000055"
    palette.buttonText: "#fcfcff"

    font.family: "pixelon"
    font.pointSize: 12

    focus: true

    Item {
        anchors.fill: parent

        Image {
          id: imageContainer
          anchors.fill: parent
          z: -2
          source: config.BackgroundPlaceholder
          visible: true
          fillMode: Image.PreserveAspectCrop
        }

        Item {
          id: videoContainer
          anchors.fill: parent
          z: -1

          VideoOutput {
            id:videoOutput
            anchors.fill: parent
            fillMode: VideoOutput.PreserveAspectCrop
          }

          MediaPlayer {
            id: videoPlayer
            videoOutput: videoOutput
            autoPlay: true
            loops: MediaPlayer.Infinite
            onPlayingChanged: (playing) => playing && (imageContainer.visible = false)
          }

          Component.onCompleted: {
            videoPlayer.source = Qt.resolvedUrl(config.Background)
            videoPlayer.play()
          }
        }

        Rectangle {
          id: formBackground

          anchors.fill: form
          anchors.centerIn: form
          z: 1

          color: root.palette.window
          visible: true
          opacity: 0.3
        }

        ColumnLayout {
          id: form

          SDDM.TextConstants {
            id: textConstants
          }

          width: parent.width / 2
          height: parent.height
          anchors.left: parent.left
          z: 2

          // Clock
          Clock {
            id: clock

            pointSize: root.font.pointSize

            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredWidth: root.width / 2
            Layout.preferredHeight: root.height / 5
            Layout.leftMargin: 0
          }

          // Form
          Form {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.preferredHeight: root.height / 8
            Layout.leftMargin: 0
            Layout.topMargin: 0
          }

          // System Button (Reboot, Shutdown, etc)
          System {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: root.height / 10
            Layout.maximumHeight: root.height / 10
          }

          // Select Session
          Session {
            id: sessionButton

            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: root.height / 18
            Layout.maximumHeight: root.height / 18
          }
        }

        MultiEffect {
          id: blur

          width: form.width
          height: parent.height
          anchors.centerIn: form
          z: -1

          blurEnabled: true
          autoPaddingEnabled: false
          blur: 2
          blurMax: 8
          visible: true
          source: ShaderEffectSource {
            sourceItem: videoOutput
            sourceRect: Qt.rect(blur.x, blur.y, blur.width, blur.height)
            visible: false
          }
        }
    }
}
