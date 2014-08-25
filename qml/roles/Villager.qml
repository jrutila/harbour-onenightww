import QtQuick 2.0
import "../js/Engine.js" as Engine

QtObject {
    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.moveTo(curPlayer.card.x, curPlayer.card.y - 20)
        infoText.text = "You are on village team.\
         Click another card to reveal your card"
    }

    function second(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("My card instance is "+curPlayer.card)
        infoText.text = "You are a "+curPlayer.role.name+". Click another card to hide your card"
        curPlayer.card.flipped = true
    }

    function third(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        curPlayer.card.flipped = false
        curPlayer.card.moveBack()
    }
}
