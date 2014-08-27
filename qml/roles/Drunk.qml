import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Item {
    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.flip(true)
        infoText.text = "You are the drunk. Click any card to switch one random middle card"
    }

    function second(card) {
        console.log("DRUNK")
        var curPlayer = Engine.getPlayer(currentPlayer)
        var curCard = curPlayer.card
        curCard.moveTo(middle2)
        middle2.moveTo(curCard)

        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        var curCard = curPlayer.card
        curPlayer.card.flip(false)
        switchBack.start()
    }

    Timer {
        id: switchBack
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            console.log("Move back")
            var curPlayer = Engine.getPlayer(currentPlayer)
            var curCard = curPlayer.card
            curCard.moveBack()
            middle2.moveBack()
        }
    }
}

