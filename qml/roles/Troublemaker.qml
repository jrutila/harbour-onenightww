import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    property var card1
    property var card2
    property bool skipped: false

    function zero() {
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        infoText.text = "You are the troublemaker. "
                + myPlayer.role.info
        helpText.text = "Click in the middle if you want to skip."
        if (state == -1)
        {
            helpText.text = "You can do the switch on the next round."
            return [1, 3]
        }
        return [1]
    }

    function second(card) {
        if (state == -1) return [2,3]

        if (card.player == myPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            helpText.text = "Skipped. Click some cards."
            return
        }
        card1 = card
        card1.zoom(true)
    }

    function third(card) {
        if (state == -1) return [2,3]

        if (skipped) return [1,4]

        if (card.player == myPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
            throw "Not from the middle!"

        card2 = card
        card2.zoom(true)

        card2.moveTo(card1)
        card1.moveTo(card2)

        if (myPlayer.role instanceof Engine.Doppelganger)
        {
            card2.player.switchedRole = card1.player.role
            card1.player.switchedRole = card2.player.role
        }

        return [1,2]
    }
}
