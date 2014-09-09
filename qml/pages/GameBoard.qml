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
    property var lComp
    property var logic
    property int clicks: 0


    SilicaFlickable {
        anchors.fill: parent
        contentHeight: parent.height
        contentWidth: parent.width

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

            Label {
                visible: gameBoard.state == 2
                color: "red"
                text: gameCanvas.votes[card.player.id]
                font.pixelSize: Theme.fontSizeHuge
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                z: 90
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

    Timer {
        property int seconds: 0
        property var done

        id: waitTimer
        interval: 1000
        running: seconds > 0
        repeat: true
        onTriggered: {
            seconds--
            if (seconds <= 0)
                done && done();
        }
    }

    Rectangle {
        visible: waitTimer.seconds > 0
        anchors.fill: parent
        color: "transparent"
        Label {
            text: "Wait for "+waitTimer.seconds
            font.pixelSize: Theme.fontSizeExtraLarge
            color: Theme.secondaryColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    PullDownMenu {
        MenuItem {
            text: qsTr("Restart")
            enabled: true
            onClicked: {
                pageStack.replace("StartPage.qml", { gameState: gameCanvas })
            }
        }
        MenuItem {
            visible: gameCanvas.debugMode
            text: "Day"
            onClicked: {
                stateChange()
            }
            anchors.right: parent.right
        }
    }
    }

    onStatusChanged: {
        if (!inited && status === PageStatus.Active && pageStack.depth === 1) {
            console.log("Show first player dialog")
            inited = true
            currentPlayer = -1
            pageStack.push(dialog)
        }
    }

    function selectCard(cc) {
        if (waitTimer.seconds > 0)
            return
        switch(state)
        {
        case -2:
            var curPlayer = Engine.getPlayer(currentPlayer)
            if (curPlayer.seeRole)
                curPlayer.card.flipped = true
            else
                curPlayer.card.zoom(true)

            wait(1, nextPlayer)
            break;
        case -1:
        case 0:
            console.log("Card "+cc.player.id+" selected")
            if (clicks == 0)
                wait(logic.first(cc))
            else if (clicks == 1)
            {
                wait(logic.second(cc))
            }
            else if (clicks == 2)
            {
                wait(logic.third(cc), nextPlayer)
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

    function wait(sec, done) {
        if (!sec || gameCanvas.debugMode)
        {
            done && done()
            return
        }
        waitTimer.done = done
        if (sec instanceof Array)
        {
            sec = sec[0]
            if (sec.length === 2)
                sec = sec[0] + Math.floor(Math.random() * (sec[1] - sec[0]))
        }
        waitTimer.seconds = sec
    }


    function doPlayerStuff() {
        recalcCards()
        createLogic()
        clicks = 0
        logic.zero()

    }

    Timer {
        id: resetTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            console.log("RESET FLIPS")
            for (var c = 0; c < rep.count; c++)
            {
                var card = rep.itemAt(c)
                card.flipped = false
                card.zoom(false)
            }
            var md = [middle1, middle2, middle3]
            for (var m = 0; m < 3; m++)
            {
                var card = md[m]
                card.zoom(false)
                card.flipped = false
            }
        }
    }

    function resetFlips() {
        resetTimer.start();
    }

    function resetUI() {
        console.log("RESET UI")
        for (var c = 0; c < rep.count; c++)
        {
            var card = rep.itemAt(c)
            card.showNewRole = false
            card.showSwitchedRole = false
            card.flipped = false
            card.moveBack()
            card.zoom(false)
        }
        var md = [middle1, middle2, middle3]
        for (var m = 0; m < 3; m++)
        {
            var card = md[m]
            card.zoom(false)
            card.flipped = false
            card.showNewRole = false
            card.showSwitchedRole = false
            card.moveBack()
        }
        helpText.text = ""
        infoText.text = ""

    }

    PlayerDialog {
        id: dialog
        player: Engine.getPlayer(currentPlayer+1)

        onOpened: {
            resetFlips();
        }
        onAccepted: {
            resetUI()
            currentPlayer++
            doPlayerStuff()
        }
        onRejected: {
            resetUI()
            currentPlayer++
            doPlayerStuff()
        }
    }

    function nextPlayer() {
        if (currentPlayer == gameCanvas.numberOfPlayers - 1)
        {
            stateChange()
            return
        }
        pageStack.push(dialog);
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

    function dayResetUI()
    {
        resetUI();
        currentPlayer = 0
        middle1.visible = false
        middle2.visible = false
        middle3.visible = false
        recalcCards();
        infoText.text = "Click the player to kill"

    }

    function stateChange() {
        console.log("State change!")
        if (state == -1)
        {
            state = 0
            currentPlayer = -1
            pageStack.push(dialog)
        }
        else if (state == 0 || state == -2)
        {
            if (state == 0)
                Engine.calcFinalRoles()

            if (state == -2 || !Engine.isRoleIn(Engine.Insomniac))
            {
                state = 1
                var dlg = pageStack.push("DayDialog.qml");
                dlg.opened.connect(function() {
                    console.log("Day dialog opened")
                    resetFlips();
                })
                dlg.accepted.connect(function() {
                    dayResetUI();
                })
                dlg.rejected.connect(function() {
                    dayResetUI();
                })
            } else {
                state = -2
                currentPlayer = -1
                /*
                pageStack.push("PlayerDialog.qml", { player: Engine.getPlayer(0) })
                   .accepted.connect(function() {
                       doPlayerStuff()
                    })
                    */
                pageStack.push(dialog)
            }
        } else if (state == 1)
        {
            currentPlayer = 0;
            state = 2;
            recalcCards();
            resetUI();
            infoText.text = "Here are the votes"
            for (var i = 0; i < gameCanvas.numberOfPlayers; i++)
            {
                var cPlayer = Engine.getPlayer(i)
                cPlayer.card.flipped = true
                cPlayer.card.showNewRole = true
            }
        }
    }

    function createLogic() {
        var pl = Engine.getPlayer(currentPlayer)
        if (!pl.logic)
        {
            var ll = loadLogic(pl.role)
            pl.logic = ll
        }
        logic = pl.logic
        logic.myPlayer = pl
        logic.myRole = pl.role
    }

    function loadLogic(role)
    {
        lComp = Qt.createComponent("../roles/"+(role.logic || role.name)+".qml")
        if (lComp.status == Component.Error)
            console.log("ERR: "+lComp.errorString())
        if (lComp.status == Component.Ready)
            return lComp.createObject(gameBoard)
    }
}
