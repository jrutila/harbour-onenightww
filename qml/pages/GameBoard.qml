import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/Engine.js" as Engine
import "../js/test.js" as Test

Page {
    id: gameBoard
    property GameCanvas gameCanvas: Engine.getGame()
    property int currentPlayer: 0

    Repeater {
        id: rep
        property int circleHeight: parent.height - 300
        property int circleWidth: parent.width - 200
        model: gameCanvas.numberOfPlayers

        Card {
            id: rect
            ind: index
            property real ang
            player: Engine.getPlayer(index)

            Component.onCompleted: {
                var middleX = parent.width / 2
                var middleY = parent.height / 2

                //var ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index
                ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index

                var mx = middleX + (rep.circleWidth/2)*Math.sin(ang)
                var my = middleY + (rep.circleHeight/2)*Math.cos(ang)
                y = my - height/2
                x = mx - width/2
                console.log(gameCanvas)
            }
            transform:
                Rotation {
                id: tRot
                origin.x: width/2
                origin.y: width/2
                axis.x: 0; axis.y: 0; axis.z: 1     // set axis.y to 1 to rotate around y-axis
                angle: rect.ang * (180/Math.PI)
            }
        }
    }

    Card {
        ind: -1
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2) - (height + 10)
        player: Engine.getMiddle(0)
    }
    Card {
        ind: -2
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2)
        player: Engine.getMiddle(1)
    }
    Card {
        ind: -3
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2) + (height + 10)
        player: Engine.getMiddle(2)
    }

    Button {
        text: "Test"
        anchors.bottom: parent.bottom;
        anchors.left: parent.left

        onClicked: {
            console.log("CLK")
            console.log(Engine.getGame().numberOfPlayers)
        }

        Component.onCompleted: {
            console.log("CMPL")
            console.log(gameCanvas.numberOfPlayers)
        }
    }
}
