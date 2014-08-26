import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: playerDialog
    property var player

    Label {
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top

        text: "Pass the device to "+ playerDialog.player.title
    }

    Label {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        text: "If you are "+ playerDialog.player.title + " flick left"
    }
}
