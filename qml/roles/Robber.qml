import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Item {
    property var switched
    property bool skipped: false

    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
        curPlayer.card.bringFront()
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.flipped = true
        infoText.text = "You are the robber. \
         Click the player you want to switch roles with.\
         Click in the middle if you want to skip."
    }

    function second(card) {
        console.log("DRUNK")
        var curPlayer = Engine.getPlayer(currentPlayer)
        if (card.player == curPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            return
        }
        card.flipped = true
        var curCard = curPlayer.card
        curCard.moveTo(card)
        card.moveTo(curCard)

        switched = card
        curPlayer.role.switched = card.player

        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        if (skipped) return
        var curPlayer = Engine.getPlayer(currentPlayer)
        var curCard = curPlayer.card
        curCard.flipped = false
        switched.flipped = false
        switchBack.start()
    }

    Timer {
        id: switchBack
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            var curPlayer = Engine.getPlayer(currentPlayer)
            var curCard = curPlayer.card
            switched.moveBack()
            curCard.moveBack()
        }
    }
}
