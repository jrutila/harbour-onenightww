import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        infoText.text = qsTr("Click a card to start")
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        myPlayer.card.bringFront()
        infoText.text = qsTr("You are the drunk.")
        helpText.text = qsTr("Click any card to switch one random middle card")
        if (state == -1)
            helpText.text = qsTr("The change happens on next turn. Click a card.")
        return [1,2]
    }

    function second(card) {
        if (state == 0)
        {
            myPlayer.card.moveTo(middle2)
            middle2.moveTo(myPlayer.card)

            if (myPlayer.role instanceof Engine.Doppelganger)
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
                    } else {
                        var card = middle2
                        card.player = m
                        m.card = card
                        card.showSwitchedRole = false
                        card.zoom(true)
                    }
                }
                console.log("DoppelgangerDrunk switched with "+middle2.player.role.name)
                myPlayer.switchedRole = middle2.player.role
                middle2.player.switchedRole = myPlayer.role
            }
        }

        infoText.text = qsTr("Click any card once more to close the cards")
        return [2,3]
    }

    function third(card) {
        myPlayer.card.flipped = false
        return [1]
    }
}

