import QtQuick 2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    property var logic
    property bool skipped: false

    function zero() {
        infoText.text = "You are the Doppelganger"
        if (state == 0)
        {
            infoText.text = "You were the Doppelganger."+
            "Now "+ (myPlayer.switchedRole != undefined ? myPlayer.switchedRole.name : myPlayer.role.newRole.name)
            myPlayer.card.showNewRole = true
            myPlayer.card.showSwitchedRole = true
        }
        myPlayer.card.flipped = true
        myPlayer.card.bringFront()
    }

    function first(card) {
        if (state == 0) return [1, 3]
        if (card.player == myPlayer)
            throw "Not yourself"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            helpText.text = "Skipped."
            return
        }
        card.flipped = true
        myRole = card.player.role
        helpText.text = "Your new role is "+myRole.name
        myPlayer.role.newRole = myRole

        logic = loadLogic(myRole)
        logic.state = 0
        logic.myPlayer = myPlayer
        logic.myRole = myRole
    }

    function second(card) {
        if (skipped) return [0,2]

        if (state == 0)
        {
            if(!(
              myRole instanceof Engine.Werewolf ||
              myRole instanceof Engine.Mason ||
              myRole instanceof Engine.Minion
                    ))
                return [1,3]
        }
        myPlayer.card.showNewRole = true

        return logic.second(card)
    }

    function third(card) {
        if (skipped) {
            myPlayer.card.showNewRole = false
            return [1,3]
        }
        if (state == 0)
        {
            if(!(
              myRole instanceof Engine.Werewolf ||
              myRole instanceof Engine.Mason ||
              myRole instanceof Engine.Minion
                    ))
                return [1,3]
        }
        return logic.third(card)
    }

    Timer {
        id: switchBack
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            myPlayer.card.showNewRole = false
            myPlayer.card.showSwitchedRole = false
            myPlayer.card.moveBack()
        }
    }
}
