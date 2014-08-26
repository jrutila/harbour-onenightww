.pragma library
var gameState
function getGame() {
    return gameState;
}

function initGameState(st) {
    console.log("initing gamestate")
    gameState = st;
    gameState.roles =[
    new Werewolf(),
    new Werewolf(),
    new Seer(),
    new Robber(),
    new Troublemaker(),
    new Villager(),
    new Villager(),
    new Villager(),
    new Drunk(),
    new Minion(),
    new Mason(),
    new Mason(),
    new Hunter(),
    new Tanner(),
        ]
    gameState.readyToStart = false;
    gameState.players = []
    gameState.middles = []
    gameState.votes = {}
}
var villageTeam = "You are on <i>village team</i>. Kill at least one werewolf."

function Villager() {
    this.name = "Villager"
    this.info = villageTeam
}

function Drunk() {
    this.name = "Drunk"
    this.info = "You don't know who you are"
}

function Werewolf() {
    this.name = "Werewolf"
    this.info = "You are on <i>werewolf team</i>. No werewolf must die."
}
function Seer() {
    this.name = "Seer"
    this.info = villageTeam
}
function Robber() {
    this.name = "Robber"
    this.switched = null
    this.info = "You are..."
}
function Troublemaker() {
    this.name = "Troublemaker"
    this.switched = []
    this.info = villageTeam
}
function Mason() {
    this.name = "Mason"
    this.info = villageTeam
}
function Minion() {
    this.name = "Minion"
    this.info = "You are on <i>werewolf team</i>. No werewolf must die, but you can."
}
function Tanner() {
    this.name = "Tanner"
    this.logic = "Villager"
    this.info = "Try to get yourself killed!"
}
function Hunter() {
    this.name = "Hunter"
    this.logic = "Villager"
    this.info = "The player you point at will die. You are on <i>village team</i>"
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
}

function getPlayer(id) {
    console.log("get player "+id)
    return gameState.players[id];
}

function getPlayers(roleType)
{
    var ret = []
    for (var p in gameState.players)
    {
        if (gameState.players[p].role instanceof roleType)
            ret.push(gameState.players[p])
    }
    for (var m in gameState.middles)
        if (gameState.middles[m].role instanceof roleType)
            ret.push(gameState.middles[m])
    return ret;
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

function calcResults()
{

}

function vote(voter, voted)
{
    gameState.votes[voter] = voted
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
