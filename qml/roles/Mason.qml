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
        curPlayer.card.flipped = true
        infoText.text = "You are a mason. Click any card to see others"
    }

    function second(card) {
        var masons = Engine.getPlayers(Engine.Mason)
        for (var m in masons)
        {
            masons[m].card.flipped = true
        }
        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        var masons = Engine.getPlayers(Engine.Mason)
        for (var m in masons)
        {
            masons[m].card.flipped = false
        }
    }
}
