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
    new Minion(),
    new Mason(),
    new Mason(),
        ]
    gameState.selectedRoles = [0,1,2,3,4,5,6];
    gameState.numberOfPlayers = 4;
    gameState.classic = false;
    gameState.readyToStart = false;
    gameState.players = []
    gameState.middles = []
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
function Mason() {
    this.name = "mason"
}
function Minion() {
    this.name = "minion"
}

function Player(id) {
    this.id = id;
    this.title = "P "+(id+1);
    this.role = undefined;
}

function Middle(id) {
    this.id = id;
    this.title = "";
    this.role = undefined;
}

function startGame() {
    var selRols = gameState.selectedRoles.slice();
    for (var p = 0; p < gameState.numberOfPlayers; p++)
    {
        var desiredIndex = Math.floor(Math.random() * selRols.length);
        var roleInd = selRols.splice(desiredIndex, 1)[0];
        var pl = new Player(p)
        pl.role = gameState.roles[roleInd];
        gameState.players[p] = pl;
    }
    for (var s = 0; s < 3; s++)
    {
        var desiredIndex = Math.floor(Math.random() * selRols.length);
        var roleInd = selRols.splice(desiredIndex, 1)[0];
        var pl = new Middle(s)
        pl.role = gameState.roles[roleInd];
        gameState.middles.push(pl);
    }

    console.log(gameState.players)
    console.log(gameState.middles)
}

function getPlayer(id) {
    return gameState.players[id];
}

function getMiddle(id) {
    return gameState.middles[id];
}

function readyToStart() {
    var roles = gameState.selectedRoles.length
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
    return gameState.selectedRoles.indexOf(index) > -1;
}

function toggleRole(index) {
    var roles = gameState.selectedRoles.length
    if (isSelected(index))
        gameState.selectedRoles.splice(gameState.selectedRoles.indexOf(index), 1);
    else if (roles < gameState.numberOfPlayers + 3)
        gameState.selectedRoles.push(index);
    console.log(gameState.selectedRoles)
    readyToStart();
}
