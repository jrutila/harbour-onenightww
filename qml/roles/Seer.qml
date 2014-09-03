import QtQuick 2.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        helpText.text = "Click a card to start"
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.showSwitchedRole = false
        myPlayer.card.flipped = true
        infoText.text = "You are the seer. "+myPlayer.role.info
        helpText.text = "Click any player or any middle card to see it. \
        Click yourself to skip."
        if (state == -1)
        {
            helpText.text = "You can peek at the card next round"
        }
    }

    function second(card) {
        if (state == -1) return [1,3]
        if (card.player instanceof Engine.Middle)
        {
            var sk = Math.floor(Math.random() * 3)
            var md = [middle1, middle3]
            for (var i = 0; i < 3; i++)
            {
                var m = Engine.getMiddle(i)
                if (i != sk)
                {
                    var card = md.pop()
                    card.player = m
                    m.card = card
                    card.showSwitchedRole = true
                    card.flipped = true
                } else {
                    var card = middle2
                    card.player = m
                    m.card = card
                }
            }
        }
        else if (myPlayer.card == card) {
            helpText.text = "Skipped. Click some cards"
        }  else {
            card.showNewRole = false
            card.showSwitchedRole = true
            card.flipped = true
        }

        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        if (state == -1) return [1,3]
    }
}
