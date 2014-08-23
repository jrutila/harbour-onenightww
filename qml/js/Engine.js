.pragma library
var gameState
function getGame() { return gameState; }
function initGameState(st) {
    console.log("initing gamestate")
    gameState = st;
    gameState.roles =[
    new Villager(),
    new Villager(),
    new Villager(),
    new Werewolf(),
    new Werewolf(),
    new Werewolf(),
    new Seer(),
    new Robber(),
        ]
    gameState.selectedRoles = {}
    gameState.numberOfPlayers = 4;
    gameState.classic = false;
    gameState.readyToStart = false;
}

function Villager() {
    this.name = "villager"
}
function Werewolf() {
    this.name = "werewolf"
}
function Seer() {
    this.name = "seer"
}
function Robber() {
    this.name = "robber"
}

function readyToStart() {
    var roles = Object.keys(gameState.selectedRoles).length
    console.log("roles "+roles)
    gameState.readyToStart = gameState.numberOfPlayers + 3 == roles;
    return gameState.readyToStart;
}

function addRoles(list) {
    for (var r in gameState.roles)
        list.append(gameState.roles[r]);
    readyToStart()
}

function isSelected(index)  {
    var role = gameState.roles[index];
    return gameState.selectedRoles[index] == true;
}

function toggleRole(index) {
    var roles = Object.keys(gameState.selectedRoles).length
    if (gameState.selectedRoles[index])
        delete gameState.selectedRoles[index];
    else if (roles < gameState.numberOfPlayers + 3)
        gameState.selectedRoles[index] = true;
    readyToStart();
}
