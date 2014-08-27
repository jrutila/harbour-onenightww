import QtQuick 2.0
import Sailfish.Silica 1.0
import "../js/Engine.js" as Engine

Item {
    property var card1
    property var card2
    property bool skipped: false

    function zero() {
        console.log("TROUBLEMAKER")
        var curPlayer = Engine.getPlayer(currentPlayer)
        curPlayer.card.flipped = true
        curPlayer.card.bringFront()
        infoText.text = "You are the troublemaker. \
         Click the player you want to choose with.\
         Click in the middle if you want to skip."
    }

    function first(card) {
        var curPlayer = Engine.getPlayer(currentPlayer)
        if (card.player == curPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
        {
            skipped = true
            helpText.text = "Skipped."
            return
        }
        card1 = card
        card1.zoom(true)

    }

    function second(card) {
        if (skipped) return

        var curPlayer = Engine.getPlayer(currentPlayer)
        if (card.player == curPlayer)
            throw "Not yourself!"
        if (card.player instanceof Engine.Middle)
            throw "Not from the middle!"

        card2 = card
        card2.zoom(true)

        card2.moveTo(card1)
        card1.moveTo(card2)
    }

    function third(card) {
        if (skipped) return
        card2.zoom(false)
        card1.zoom(false)
        switchBack.start()
    }

    Timer {
        id: switchBack
        interval: 500
        running: false
        repeat: false
        onTriggered: {
            card1.moveBack()
            card2.moveBack()
        }
    }
}
