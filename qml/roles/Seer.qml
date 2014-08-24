import QtQuick 2.0
import "../js/Engine.js" as Engine

QtObject {
    property var seenCard

    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.flipped = true
        infoText.text = "You are the seer. Click any player or middle card to see it"
    }

    function second(card) {
        card.flipped = true
        seenCard = card
        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        seenCard.flipped = false
        var curPlayer = Engine.getPlayer(currentPlayer)
        curPlayer.card.flipped = false
    }
}
