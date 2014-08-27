import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: cardItem
    width: 130 //Theme.itemSizeSmall
    height: 180 //Theme.itemSizeSmall
    property var player
    property int ind
    property var ang: 0
    property bool flipped: false
    property alias card: flCard
    signal cardSelected(var selected)
    color: "transparent"
    z: 0

    Label {
        text: player != undefined ? player.title : "Sokko"
        color: Theme.primaryColor
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: flCard.bottom
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        onClicked: cardSelected(cardItem)
    }

    function flip(flp) {
        flipped = flp
    }

    function moveTo(cc) {
        moveAnim.toX.to = cc.x - x
        moveAnim.toY.to = cc.y - y
        moveAnim.start()
    }

    function bringFront() {
        moveAnim.toY.to = -40
        moveAnim.start()
    }

    function move(x, y)
    {
        moveAnim.toX.to = x
        moveAnim.toY.to = y
        moveAnim.start()
    }

    function moveBack() {
        cardMove.x = 0
        cardMove.y = 0
    }

    function zoom(en) {
        if (en)
        {
            flipScale.xScale = 1.5
            flipScale.yScale = 1.5
        } else {
            flipScale.xScale = 1.0
            flipScale.yScale = 1.0
        }
    }

    function setPlayer(pl) {
        player = pl
        pl.card = cardItem
    }

    Flipable {
        id: flCard
        property bool flipped: cardItem.flipped
        width: 100
        height: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        z: 2

        MouseArea {
            anchors.fill: parent
            onClicked: cardSelected(cardItem)
        }

        front: Rectangle {
            anchors.fill: parent
            color: Theme.primaryColor
        }

        back: Rectangle {
            anchors.fill: parent
            color: Theme.highlightColor

            Label {
                text: player.role.name
                color: Theme.primaryColor
                font.pixelSize: 18
            }
        }

        transform: [
            Rotation {
                id: flipRot
                origin.x: flCard.width/2
                origin.y: flCard.height/2
                axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
                angle: 0    // the default angle
            },
            Rotation {
                id: normRot
                origin.x: flCard.width/2
                origin.y: flCard.width/2
                axis.x: 0; axis.y: 0; axis.z: 1     // set axis.y to 1 to rotate around y-axis
                angle: 0 //ang * (180/Math.PI)
            },
            Scale {
                id: flipScale
                origin.x: flCard.width/2
                origin.y: flCard.height/2
                xScale: 1.0
                yScale: 1.0
            },
            Translate {
                id: cardMove
                x: 0
                y: 0
            }

        ]

        SequentialAnimation {
            id: moveAnim
            property alias toX: toX
            property alias toY: toY

            PropertyAnimation {
                id: toX
                target: cardMove
                properties: "x"
                duration: 600
                easing.type: Easing.InOutQuad
            }
            PropertyAnimation {
                id: toY
                target: cardMove
                properties: "y"
                duration: 600
                easing.type: Easing.InOutQuad
            }
        }

        transitions: Transition {
            NumberAnimation { target: flipRot; property: "angle"; duration: 300 }
            NumberAnimation { target: flipScale; property: "xScale"; duration: 300 }
            NumberAnimation { target: flipScale; property: "yScale"; duration: 300 }
            NumberAnimation { target: cardMove; property: "y"; duration: 500 }
            NumberAnimation { target: cardMove; property: "x"; duration: 500 }
        }

        states: State {
            name: "back"
            PropertyChanges { target: flipRot; angle: 180 }
            PropertyChanges { target: normRot; angle: 0 }
            PropertyChanges { target: flipScale; xScale: 2.0 }
            PropertyChanges { target: flipScale; yScale: 2.0 }
            PropertyChanges { target: flCard; z: 5 }
            when: flCard.flipped
        }
    }

    /*
    Flipable {
        id: card
        property bool flipped: cardItem.flipped
        width: 100
        height: 100


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


        function moveTo(xx, yy)
        {
            backX = x
            backY = y
            newX = xx
            newY = yy
            console.log("Moving from "+y+" to "+newY)
            move.start()
        }

        function moveBack() {
            x = backX
            y = backY
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 300 }
            NumberAnimation { target: scale; property: "xScale"; duration: 300 }
            NumberAnimation { target: scale; property: "yScale"; duration: 300 }
            NumberAnimation { target: scale; property: "yScale"; duration: 300 }
            NumberAnimation { target: tRot; property: "angle"; duration: 300 }
        }

    }
    */
}
