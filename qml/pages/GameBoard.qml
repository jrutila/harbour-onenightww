import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/Engine.js" as Engine

Page {
    id: gameBoard
    property GameCanvas gameCanvas: Engine.getGame()
    property int currentPlayer: 0
    property var curLogic
    property int state: 0
    property bool inited: false

    Repeater {
        id: rep
        property int circleHeight: parent.height - 300
        property int circleWidth: parent.width - 200
        model: gameCanvas.numberOfPlayers

        Card {
            id: card
            property int ind: index
            player: Engine.getPlayer((index+currentPlayer) % gameCanvas.numberOfPlayers)

            Component.onCompleted: {
                var middleX = parent.width / 2
                var middleY = parent.height / 2

                //var ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index
                ang = ((2*Math.PI)/gameBoard.gameCanvas.numberOfPlayers)*index

                var mx = middleX - (rep.circleWidth/2)*Math.sin(ang)
                var my = middleY + (rep.circleHeight/2)*Math.cos(ang)
                y = my - height/2
                x = mx - width/2
            }
            onCardSelected: selectCard(selected)
        }
    }

    Card {
        id: middle1
        ind: -1
        x: parent.width/2 - width/2
        y: parent.height/2 - (card.height/2) - (card.height + 10)
        player: Engine.getMiddle(0)
        onCardSelected: selectCard(selected)
    }
    Card {
        id: middle2
        ind: -2
        x: parent.width/2 - width/2
        y: parent.height/2 - (card.height/2)
        player: Engine.getMiddle(1)
        onCardSelected: selectCard(selected)
    }
    Card {
        id: middle3
        ind: -3
        x: parent.width/2 - width/2
        y: parent.height/2 - (card.height/2) + (card.height + 10)
        player: Engine.getMiddle(2)
        onCardSelected: selectCard(selected)
    }

    Label {
        text: "INFO"
        id: infoText
        anchors.top: parent.top
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.highlightColor
        z: 3
    }

    Label {
        text: ""
        id: helpText
        anchors.bottom: parent.bottom
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
        color: Theme.highlightColor
        z: 3
    }

    property var lComp
    property var logic
    property int clicks: 0

    function selectCard(cc) {

        switch(state)
        {
        case 0:
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
            break;
        case 1:
            console.log("Voting "+cc.player.id)
            var curPlayer = Engine.getPlayer(currentPlayer)
            if (cc.player instanceof Engine.Player && cc.player != curPlayer)
            {
                Engine.vote(curPlayer, cc.player)
                nextPlayer()
            }
        }
    }

    onStatusChanged: {
        if (!inited && status === PageStatus.Active && pageStack.depth === 1) {
            console.log("Show first player dialog")
            inited = true
            pageStack.push("../PlayerDialog.qml", { player: Engine.getPlayer(0) })
               .accepted.connect(function() {
                   doPlayerStuff()
                })
        }
    }

    function doPlayerStuff() {
        recalcCards()
        createLogic()
        clicks = 0
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
            stateChange()
            return
        }

        var dialog = pageStack.push("../PlayerDialog.qml", { player: Engine.getPlayer(currentPlayer+1) });
        dialog.accepted.connect(function() {
            currentPlayer++
            doPlayerStuff()
        })
    }

    function recalcCards() {
        for (var c = 0; c < rep.count; c++)
        {
            var card = rep.itemAt(c)
            var player = Engine.getPlayer((c+currentPlayer) % gameCanvas.numberOfPlayers)
            card.setPlayer(player)
        }
        middle1.setPlayer(Engine.getMiddle(0))
        middle2.setPlayer(Engine.getMiddle(1))
        middle3.setPlayer(Engine.getMiddle(2))
    }

    function stateChange() {
        console.log("State change!")
        if (state == 0)
        {
            state = 1
            var dialog = pageStack.push("DayDialog.qml");
            dialog.accepted.connect(function() {
                currentPlayer = 0
                middle1.visible = false
                middle2.visible = false
                middle3.visible = false
                recalcCards();
                infoText.text = "Click the player to kill"
            })
        } else if (state == 1)
        {
            state = 2
            infoText.text = "Here are the votes"
            for (var i = 0; i < gameCanvas.numberOfPlayers; i++)
            {
                var cPlayer = Engine.getPlayer(i)
                cPlayer.card.flipped = true
                var voted = gameCanvas.votes[cPlayer]
            }
        }
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
        text: "Restart"
        onClicked: {
            pageStack.replace("StartPage.qml", { gameState: gameCanvas })
        }
    }
    Button {
        text: "Day"
        onClicked: {
            stateChange()
        }
        anchors.right: parent.right
    }
}
