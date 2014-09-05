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
                    pageStack.push("GameBoard.qml", {
                      gameCanvas: gameCanvas,
                      state: Engine.isRoleIn(Engine.Doppelganger) ? -1 : 0
                    })
                }
            }
        }

        anchors.fill: parent
        cellWidth: parent.width / 3
        cellHeight: parent.height / 6

        header: PageHeader {
            title: qsTr("Pick roles")
        }

        Label {
            property int players: gameCanvas.numberOfPlayers + 3 - gameCanvas.selectedRoles.length
            anchors.top: parent.top
            text: "Choose "+players
        }

        delegate: Rectangle {
            id: delegate
            property bool selected: Engine.isSelected(index)
            width: listView.cellWidth
            height: listView.cellHeight
            color: "transparent" // Theme.primaryColor
            //border.color: "red" // selected ? Theme.highlightColor : Theme.primaryColor
            //border.width: 1

            Image {
                //anchors.fill: parent
                id: img
                source: "../../images/"+name+".png"
                fillMode: Image.PreserveAspectCrop
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                width: listView.cellWidth
                height: parent.height
                //height: parent.height
            }

            ShaderEffect {
                width: listView.cellWidth;
                height: parent.height
                visible: !selected
                property variant src: img
                vertexShader: "
                    uniform highp mat4 qt_Matrix;
                    attribute highp vec4 qt_Vertex;
                    attribute highp vec2 qt_MultiTexCoord0;
                    varying highp vec2 coord;
                    void main() {
                        coord = qt_MultiTexCoord0;
                        gl_Position = qt_Matrix * qt_Vertex;
                    }"
                fragmentShader: "
                    varying highp vec2 coord;
                    uniform sampler2D src;
                    uniform lowp float qt_Opacity;
                    void main() {
                        lowp vec4 tex = texture2D(src, coord);
                        gl_FragColor = vec4(vec3(dot(tex.rgb, vec3(0.344, 0.5, 0.156))), tex.a) * qt_Opacity;
                    }"
            }

            Label {
                x: Theme.paddingLarge
                text: qsTr(name)
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                font.bold: true
                font.family: "Helvetica [Cronyx]"
                font.pixelSize: Theme.fontSizeSmall
                color: selected ? "white" : "grey"
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
