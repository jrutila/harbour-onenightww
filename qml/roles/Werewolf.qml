import QtQuick 2.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        helpText.text = "Click a card to start"
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        infoText.text = "You are a "+myRole.name+". "+
                myRole.info
        helpText.text = "Click any card to see others"
        if (state == -1)
        {
            helpText.text = "You see others in next round. Click a card."
        }
    }

    function second(card) {
        if (state == -1) return [1,3]
        var others = Engine.getPlayers(myRole.constructor)
        for (var o in others)
        {
            others[o].card.showNewRole = true
            others[o].card.flipped = true
        }
        helpText.text = "Click a card once more to close the cards"
    }

    function third(card) {
        if (state == -1) return [1,3]
        var others = Engine.getPlayers(myRole.constructor)
        for (var o in others)
        {
            others[o].card.flipped = false
            others[o].card.showNewRole = false
        }
    }
}
