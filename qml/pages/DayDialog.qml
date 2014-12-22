import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import "../js/Engine.js" as Engine

Dialog {
    id: dayDialog
    property GameCanvas gameCanvas: Engine.getGame()

    Label {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        text: ""
    }

    Repeater {
        id: rep
        property int circleHeight: parent.height - 300
        property int circleWidth: parent.width - 200
        model: gameCanvas.selectedRoles

        Card {
            id: card
            property int ind: index
            player: Engine.getRoleOrdered(ind)
            flipScaleX: 1.25
            flipScaleY: 1.25

            Component.onCompleted: {
                var aa = [0, 1, 2, 1];
                var w = parent.width / 4;
                var middleY = parent.height / (gameCanvas.selectedRoles.length + 2)

                x = w + aa[(ind%4)]*w - (card.width / 2);

                y = middleY * ind

                flip(true);
            }
        }
    }
}
