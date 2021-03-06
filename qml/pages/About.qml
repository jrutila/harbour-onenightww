import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    SilicaFlickable {
        anchors {
            margins: Theme.paddingLarge
            left: parent.left
            right: parent.right
        }
        contentHeight: column.height

        Column {
            id: column
            width: parent.width

            PageHeader { title: "About" }
            Label {
                color: Theme.highlightColor
                text: "This is One Night Ultimate Werewolf"
            }
            Label {
                color: Theme.highlightColor
                text: "What? No fancy graphics?"
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                text: "I can't distribute the official images for obvious reasons. You can use your own graphics."
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                text: "Copy your images to the path /usr/share/harbour-onenightww/images"
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                text: "Card back image: cardback.png
For each role add a png image by the roles name (e.g. Robber.png, Troublemaker.png)
Images should be size of 153x153"
            }
            Label {
                width: parent.width
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                text: "Icon image by <a>https://www.flickr.com/photos/ghetzu/3535994578/</a>"
            }
        }
    }
}
