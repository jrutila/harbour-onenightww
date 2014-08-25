import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/Engine.js" as Engine

Page {
    id: gameBoard
    property GameCanvas gameCanvas: Engine.getGame()
    property int currentPlayer: 0
    property var curLogic

    Repeater {
        id: rep
        property int circleHeight: parent.height - 300
        property int circleWidth: parent.width - 200
        model: gameCanvas.numberOfPlayers

        Card {
            id: rect
            ind: index
            property real ang
            player: Engine.getPlayer((index+currentPlayer) % gameCanvas.numberOfPlayers)

            Component.onCompleted: {
                player.card = rect

                var middleX = parent.width / 2
                var middleY = parent.height / 2

                //var ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index
                ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index

                var mx = middleX - (rep.circleWidth/2)*Math.sin(ang)
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

            onCardSelected: selectCard(selected)
        }
    }

    Card {
        id: middle1
        ind: -1
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2) - (height + 10)
        player: Engine.getMiddle(0)
        onCardSelected: selectCard(selected)
        Component.onCompleted: {
            player.card = middle1
        }
    }
    Card {
        id: middle2
        ind: -2
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2)
        player: Engine.getMiddle(1)
        onCardSelected: selectCard(selected)
        Component.onCompleted: {
            player.card = middle2
        }
    }
    Card {
        id: middle3
        ind: -3
        x: parent.width/2 - width/2
        y: parent.height/2 - (height/2) + (height + 10)
        player: Engine.getMiddle(2)
        onCardSelected: selectCard(selected)
        Component.onCompleted: {
            player.card = middle3
        }
    }

    Label {
        text: "INFO"
        id: infoText
        anchors.top: parent.top
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        z: 3
    }

    Label {
        text: ""
        id: helpText
        anchors.bottom: parent.bottom
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        z: 3
    }

    property var lComp
    property var logic
    property int clicks: 0

    function selectCard(cc) {
        console.log("Card "+cc.player.id+" selected")
        if (clicks == 0)
            logic.first(cc)
        else if (clicks == 1)
        {
            var pl = Engine.getPlayer(currentPlayer)
            logic.second(cc)
            helpText.text = pl.role.info
        }
        else if (clicks == 2)
        {
            logic.third(cc)
            nextPlayer()
        }
        clicks++
    }

    Component.onCompleted:
    {
        createLogic()
        logic.zero()
    }

    function nextPlayer() {

        for (var c = 0; c < rep.count; c++)
        {
            rep.itemAt(c).flipped = false
        }
        middle1.flipped = false
        middle2.flipped = false
        middle3.flipped = false
        helpText.text = ""
        if (currentPlayer == gameCanvas.numberOfPlayers - 1)
        {
            return
        }

        var dialog = pageStack.push("../PlayerDialog.qml", { player: Engine.getPlayer(currentPlayer+1) });
        dialog.accepted.connect(function() {
            currentPlayer++
            for (var c = 0; c < rep.count; c++)
            {
                var card = rep.itemAt(c)
                var player = Engine.getPlayer((c+currentPlayer) % gameCanvas.numberOfPlayers)
                card.player = player
                player.card = card
            }

            createLogic()
            clicks = 0
            logic.zero()
        })
    }

    function createLogic() {
        var pl = Engine.getPlayer(currentPlayer)
        lComp = Qt.createComponent("../roles/"+(pl.role.logic || pl.role.name)+".qml")
        if (lComp.status == Component.Error)
            console.log("ERR: "+lComp.errorString())
        if (lComp.status == Component.Ready)
            logic = lComp.createObject(gameBoard)
    }

    Button {
        text: Restart
        onClicked: {
            pageStack.replace("StartPage.qml", { gameState: gameCanvas })
        }
    }
}
