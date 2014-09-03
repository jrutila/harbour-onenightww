import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    property var switched
    property bool skipped: false

    function zero() {
        myPlayer.card.bringFront()
    }

    function first(card) {
        myPlayer.card.flipped = true
        infoText.text = "You are the robber."
        helpText.text = "Click a player to steal. Click in the middle to skip."
        if (state == -1)
        {
            helpText.text = "You can steal on the next round. Click some cards."
            return [1, 3]
        }
        return [1]
    }

    function second(card) {
        if (state == -1) return [1, 4]
        if (card.player == myPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            return [1,3]
        }

        card.showSwitchedRole = true
        card.flipped = true

        myPlayer.card.moveTo(card)
        card.moveTo(myPlayer.card)

        switched = card
        myRole.switched = card.player

        infoText.text = "You are now "+switched.player.role.name+switched.player.role.name
                + " " + switched.player.role.info
        helpText.text = "Click any card once more to close the cards"
    }

    function third(card) {
        if (state == -1) return [1, 4]
        if (skipped) return [1, 3]
        myPlayer.card.flipped = false
        switched.flipped = false

        if (myPlayer.role instanceof Engine.Doppelganger)
        {
            switched.player.switchedRole = myPlayer.role
            myPlayer.switchedRole = switched.player.role
        }
    }
}
