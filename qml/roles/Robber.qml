import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Item {
    property var switched
    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.flipped = true
        infoText.text = "You are the robber. \
         Click the player you want to choose with.\
         Click in the middle if you want to skip."
    }

    function second(card) {
        console.log("DRUNK")
        card.flipped = true
        var curPlayer = Engine.getPlayer(currentPlayer)
        var curCard = curPlayer.card
        var mx = card.x
        var my = card.y
        var cx = curCard.x
        var cy = curCard.y
        curCard.moveTo(mx, my)
        card.moveTo(cx, cy)

        switched = card
        curPlayer.role.switched = card.player

        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
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
