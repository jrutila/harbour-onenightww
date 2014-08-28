import QtQuick 2.0
import "../js/Engine.js" as Engine

Role {
    property int state: gameBoard.state
    property var wolves

    function zero() {
        helpText.text = "Click a card to start"
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        infoText.text = "You are the minion."
        helpText.text = "Click any card to see werewolves"
        if (state == -1)
        {
            helpText.text = "You see the werewolves in next round."
        }
    }

    function second(card) {
        if (state == -1) return [1,3]
        wolves = Engine.getPlayers(Engine.Werewolf)
        for (var w in wolves)
        {
            wolves[w].card.showNewRole = true
            wolves[w].card.flipped = true
        }
        infoText.text = "Click a card once more to close the cards"
        return [2, 4]
    }

    function third(card) {
        if (state == -1) return [1,3]
        for (var w in wolves)
        {
            wolves[w].card.flipped = false
            wolves[w].card.showNewRole = false
        }
    }
}
