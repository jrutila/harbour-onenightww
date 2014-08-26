import QtQuick 2.0

QtObject {
    property var roles
    property var selectedRoles: [0,1,2,3,4,5,6]
    property int numberOfPlayers: 4
    property bool classic: false
    property bool readyToStart
    property var players
    property var middles
    property var switches
    property var votes
}
