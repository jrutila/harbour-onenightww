/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/Engine.js" as Engine

Page {
    id: page
    forwardNavigation: true
    property GameCanvas gameState//: Engine.getGame()
    property bool debugMode: gameState.debugMode

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        contentWidth: column.width

        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: {
                    pageStack.push("About.qml")
                }
            }
        }

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Start new game")
            }
            Label {
                x: Theme.paddingLarge
                text: qsTr("Number of players")+ " " + gameState.numberOfPlayers
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            Slider {
                id: nbrSlider
                minimumValue: 3
                maximumValue: 10
                value: gameState.numberOfPlayers
                stepSize: 1.0
                width: parent.width
                onValueChanged: gameState.numberOfPlayers = value
            }
            Repeater {
                id: names
                model: nbrSlider.value
                delegate: TextField {
                    id: playerName
                    width: column.width
                    EnterKey.iconSource:
                        index == names.count-1 ?
                        "image://theme/icon-m-enter-close" :
                        "image://theme/icon-m-enter-next"
                    EnterKey.onClicked: {
                        if (index == names.count-1)
                            focus = false
                        else
                        {
                            names.itemAt(index+1).focus = true
                            names.itemAt(index+1).selectAll()
                        }
                    }
                    onClicked: selectAll()
                    onTextChanged: {
                        if (gameState.playerNames == undefined)
                            gameState.playerNames = {}
                        console.log("setText "+index+" "+text)
                        gameState.playerNames[index] = text
                    }

                    Component.onCompleted: {
                        if (gameState.playerNames && gameState.playerNames[index])
                            text = gameState.playerNames[index]
                        else
                            text = "P " + (index + 1)
                    }
                }
            }

            TextSwitch {
                checked: debugMode
                text: qsTr("Debug Mode")
                automaticCheck: false
                onClicked: {
                    gameState.debugMode = !gameState.debugMode
                }
            }
            TextSwitch {
                visible: gameState.debugMode
                checked: gameState.debugRandomize
                text: qsTr("Debug: Randomize roles")
                automaticCheck: false
                onClicked: {
                    gameState.debugRandomize = !gameState.debugRandomize
                }
            }
        }
    }

    Component.onCompleted: {
        Engine.initGameState(gameState)
    }

    onStatusChanged: {
        console.log("status "+PageStatus.Active)
        if (status === PageStatus.Active && pageStack.depth === 1) {
            pageStack.pushAttached("SecondPage.qml", { names: names })
        }
    }
}


