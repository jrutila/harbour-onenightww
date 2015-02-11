import QtQuick 2.0

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Role {
    property var logic
    property bool skipped: false
    property var chosen

    function zero() {
        infoText.text = qsTr("You are the Doppelganger.") + " "
        if (state == -2)
            return
        if (state == 0)
        {
            infoText.text = qsTr("You were the Doppelganger.") + " "
            if (myPlayer.role.newRole instanceof Engine.Drunk)
                infoText.text += qsTr("Now you are Drunk and don't know your new role.") + " "
            else
                infoText.text += qsTr("Now")+ " "+ (myPlayer.switchedRole != undefined ? myPlayer.switchedRole.desc : myPlayer.role.newRole.desc)
            myPlayer.card.showNewRole = true
        }
        myPlayer.card.flipped = true
        myPlayer.card.bringFront()
    }

    function first(card) {
        if (state == 0) {
            if (!myPlayer.role.newRole instanceof Engine.Drunk)
            {
                infoText.text = qsTr("And switched to")+" "+myPlayer.switchedRole.desc
                myPlayer.card.showSwitchedRole = true
            }
            chosen.flipped = true
            return [1, 3]
        }
        if (card.player == myPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            helpText.text = qsTr("Skipped.")
            return
        }
        chosen = card
        card.flipped = true
        myRole = new card.player.role.constructor()
        helpText.text = qsTr("Your new role is")+" "+myRole.desc
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
            {
                logic.second(card)
                return [1,3]
            }
        }
        myPlayer.card.showNewRole = true

        return logic.second(card)
    }

    function third(card) {
        if (skipped) {
            myPlayer.card.showSwitchedRole = false
            return [1,3]
        }
        if (state == 0)
        {
            if(!(
              myRole instanceof Engine.Werewolf ||
              myRole instanceof Engine.Mason ||
              myRole instanceof Engine.Minion
                    ))
            {
                logic.third(card)
                return [1,3]
            }
        }
        return logic.third(card)
    }
}
