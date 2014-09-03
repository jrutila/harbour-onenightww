import QtQuick 2.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        helpText.text = "Click a card to start"
    }

    function first(card) {
        myPlayer.card.bringFront()
        helpText.text = "Click a card again"
        return [1, 3]
    }

    function second(card) {
        infoText.text = "You are a "+myPlayer.role.name+"."
                + myPlayer.role.info
        helpText.text = "Click a card to close"
        myPlayer.card.flipped = true
        return [1, 3]
    }

    function third(card) {
        myPlayer.card.flipped = false
        return [1]
    }
}
