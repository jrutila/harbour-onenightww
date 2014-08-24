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
        infoText.text = "Click another card to reveal your card"
    }

    function second(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("My card instance is "+curPlayer.card)
        curPlayer.card.flipped = true
        infoText.text = "Click a card once more to close your card"
    }

    function third(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        curPlayer.card.flipped = false
    }
}
