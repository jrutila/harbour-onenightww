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
    property GameCanvas gameCanvas: Engine.getGame()

    SilicaGridView {
        id: listView
        model: ListModel {
            id: roleList
            Component.onCompleted: {
                Engine.addRoles(roleList);
            }
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Start")
                enabled: gameCanvas.readyToStart
                onClicked: {
                    Engine.startGame();
                    pageStack.clear();
                    pageStack.push("GameBoard.qml", { gameCanvas: gameCanvas })
                    pageStack.push("../PlayerDialog.qml", { player: Engine.getPlayer(0) });
                }
            }
        }

        anchors.fill: parent
        cellWidth: parent.width / 3
        cellHeight: parent.height / 6

        header: PageHeader {
            title: qsTr("Choose " + (gameCanvas.numberOfPlayers + 3 - gameCanvas.selectedRoles.length) + " roles")
        }

        delegate: Rectangle {
            id: delegate
            property bool selected: Engine.isSelected(index)
            width: listView.cellWidth
            height: listView.cellHeight
            color: "red"
            border.color: selected ? Theme.highlightColor : Theme.primaryColor
            border.width: 5

            Label {
                x: Theme.paddingLarge
                text: qsTr(name)
                anchors.verticalCenter: parent.verticalCenter
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    Engine.toggleRole(index);
                    delegate.selected = Engine.isSelected(index)
                }
            }
        }
    }
}
