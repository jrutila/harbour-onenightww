import QtQuick 2.0
import "../js/Engine.js" as Engine

Role {
    function zero() {
        helpText.text = qsTr("Click a card to start")
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        infoText.text = qsTr("You are a")+" "+myRole.desc+". "+
                myRole.info
        helpText.text = qsTr("Click any card to see others")
        if (state == -1)
        {
            helpText.text = qsTr("You see others in next round. Click a card.")
        }
        if (state == 0)
        {
            var others = Engine.getPlayers(myRole.constructor)
            for (var o in others)
            {
                others[o].card.showNewRole = true
            }
        }
    }

    function second(card) {
        if (state == -1) return [1,3]
        var others = Engine.getPlayers(myRole.constructor)
        for (var o in others)
        {
            others[o].card.flipped = true
        }
        helpText.text = qsTr("Click a card once more to close the cards")
    }

    function third(card) {
        if (state == -1) return [1,3]
        var others = Engine.getPlayers(myRole.constructor)
        for (var o in others)
        {
            others[o].card.flipped = false
        }
        return [1,2]
    }
}
