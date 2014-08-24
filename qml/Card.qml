import QtQuick 2.0
import Sailfish.Silica 1.0

Flipable {
    id: card
    width: 100
    height: 100
    property bool flipped: false
    property int ind
    property var player

    signal cardSelected

    front: Rectangle {
        anchors.fill: parent
        color: Theme.primaryColor

        Label {
            text: card.player != undefined ? card.player.title : "Sokko"
            color: "black"
            rotation: -1*tRot.angle
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    back: Rectangle {
        anchors.fill: parent
        color: Theme.highlightColor

        Label {
            text: card.player.role.name
            color: "red"

        }
    }

    transform: [
        Rotation {
         id: rotation
         origin.x: card.width/2
         origin.y: card.height/2
         axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
         angle: 0    // the default angle
        },
        Scale {
         id: scale
         origin.x: card.width/2
         origin.y: card.height/2
         xScale: 1.0
         yScale: 1.0
        }
    ]

     states: State {
         name: "back"
         PropertyChanges { target: rotation; angle: 180 }
         PropertyChanges { target: scale; xScale: 2.0 }
         PropertyChanges { target: scale; yScale: 2.0 }
         PropertyChanges { target: tRot; angle: 0 }
         PropertyChanges { target: card; z: 1 }
         when: card.flipped
     }

     transitions: Transition {
         NumberAnimation { target: rotation; property: "angle"; duration: 300 }
         NumberAnimation { target: scale; property: "xScale"; duration: 300 }
         NumberAnimation { target: scale; property: "yScale"; duration: 300 }
         NumberAnimation { target: scale; property: "yScale"; duration: 300 }
         NumberAnimation { target: tRot; property: "angle"; duration: 300 }
     }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        onClicked: card.flipped = !card.flipped
    }
}
