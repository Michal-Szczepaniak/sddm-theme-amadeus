// Copyright © 2018 Michał Szczepaniak <m.szczepaniak.000@gmail.com>
// This work is free. You can redistribute it and/or modify it under the
// terms of the Do What The Fuck You Want To Public License, Version 2,
// as published by Sam Hocevar. See the COPYING file for more details.

import QtQuick 2.0
import SddmComponents 2.0
import "./components"

Rectangle {
  id  : amadeus_root

  property var scalingX: 1920/bg.paintedWidth
  property var scalingY: 1080/bg.paintedHeight
  property var diffX: (amadeus_root.width - bg.paintedWidth)/2
  property var diffY: (amadeus_root.height - bg.paintedHeight)/2
  property var inputColor: "#debf54"
  property var glow: "#60e6b656"

  signal tryLogin()

  onTryLogin : {
    sddm.login(amadeus_username.text, amadeus_password.text, sessionModel.lastIndex);
  }

  FontLoader {
    id: takao_mincho
    source: "fonts/TakaoMincho.ttf"
  }

  TextConstants { id: textConstants }

  
  Loader {
      id: vkloader
      source: "vk.qml"
  }

  Connections {
    target: sddm

    onLoginSucceeded: {
    }

    onLoginFailed: {
    }
  }

  Repeater {
    model: screenModel

    Item {
      Rectangle {
        x       : geometry.x
        y       : geometry.y
        width   : geometry.width
        height  : geometry.height
        color   : "black"
      }
    }
  }

  Image {
    id: bg
    anchors.fill: parent
    source: "amadeus-background.png"
    fillMode: Image.PreserveAspectFit

    clip: true
    focus: true
    smooth: true
  }

  SpTextBox {
    id: amadeus_username

    x: 683/amadeus_root.scalingX + diffX
    y: 633/amadeus_root.scalingY + diffY

    width: 560/amadeus_root.scalingX
    height: 42/amadeus_root.scalingY

    color: "black"
    borderColor: "black"
    focusColor: "#000"
    hoverColor: "#000"
    textColor: inputColor
    glowColor: glow

    font.family: takao_mincho.name
    font.pixelSize: 27/amadeus_root.scalingY
    font.letterSpacing: 1.4
    font.bold: true

    KeyNavigation.tab: amadeus_password
  }

  SpTextBox {
    id: amadeus_password

    x: 683/amadeus_root.scalingX + diffX
    y: 699/amadeus_root.scalingY + diffY

    width: 560/amadeus_root.scalingX
    height: 46/amadeus_root.scalingY

    echoMode: TextInput.Password

    color: "black"
    borderColor: "black"
    focusColor: "#000"
    hoverColor: "#000"
    textColor: inputColor
    glowColor: glow

    font.family: takao_mincho.name
    font.pixelSize: 27/amadeus_root.scalingY

    KeyNavigation.tab: amadeus_login
    KeyNavigation.backtab: amadeus_username

    Keys.onPressed: {
      if ((event.key === Qt.Key_Return) || (event.key === Qt.Key_Enter)) {
        amadeus_root.tryLogin()

        event.accepted = true;
      }
    }
  }

  MouseArea {
      id: amadeus_login

      x       : 1254/amadeus_root.scalingX + diffX
      y       : 695/amadeus_root.scalingY + diffY
      width   : 50/amadeus_root.scalingX
      height  : 50/amadeus_root.scalingY

      cursorShape: Qt.PointingHandCursor

      hoverEnabled: true
      enabled: true

      acceptedButtons: Qt.LeftButton

      onClicked: { amadeus_root.tryLogin() }
  }

  Component.onCompleted: {
    if (amadeus_username.text === "")
      amadeus_username.focus = true
    else
      amadeus_password.focus = true
  }
}
