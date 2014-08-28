import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        infoText.text = "Click a card to start"
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        myPlayer.card.bringFront()
        infoText.text = "You are the drunk."
        helpText.text = "Click any card to switch one random middle card"
        if (state == -1)
            helpText.text = "The change happens on next turn. Click a card."
        return [1,2]
    }

    function second(card) {
        if (state == 0)
        {
            myPlayer.card.moveTo(middle2)
            middle2.moveTo(myPlayer.card)
        }

        infoText.text = "Click any card once more to close the cards"
        return [2,3]
    }

    function third(card) {
        myPlayer.card.flipped = false
        switchBack.start()
        return [1]
    }

    Timer {
        id: switchBack
        interval: 1500
        running: false
        repeat: false
        onTriggered: {
            myPlayer.card.moveBack()
            middle2.moveBack()
        }
    }
}

