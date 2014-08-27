import QtQuick 2.0
import "../js/Engine.js" as Engine

QtObject {
    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
        curPlayer.card.bringFront()
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
        curPlayer.card.flipped = true
        infoText.text = "You are the minion. Click any card to see werewolves"
    }

    function second(card) {
        var wolves = Engine.getPlayers(Engine.Werewolf)
        for (var w in wolves)
        {
            console.log(wolves[w].card)
            wolves[w].card.flipped = true
        }
        infoText.text = "Click a card once more to close the cards"
    }

    function third(card) {
        var wolves = Engine.getPlayers(Engine.Werewolf)
        for (var w in wolves)
        {
            wolves[w].card.flipped = false
        }
    }
}
