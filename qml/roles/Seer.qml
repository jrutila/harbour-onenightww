import QtQuick 2.0
import "../js/Engine.js" as Engine

QtObject {
    function zero() {
        var curPlayer = Engine.getPlayer(currentPlayer)
        infoText.text = "Click a card to start"
        curPlayer.card.bringFront()
        console.log("Current player "+currentPlayer+" is "+curPlayer.role.name)
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        curPlayer.card.flipped = true
        infoText.text = "You are the seer. \
        Click any player or middle card to see it. \
        Click yourself to skip."
    }

    function second(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
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
                    card.flipped = true
                } else {
                    var card = middle2
                    card.player = m
                    m.card = card
                }
            }
        }
        else if (curPlayer.card == card) {
            helpText.text = "Skipped."
        }  else {
            card.flipped = true
        }

        infoText.text = "Click any card once more to close the cards"
    }

    function third(card) {
    }
}
