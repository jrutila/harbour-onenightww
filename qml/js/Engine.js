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
    new Hunter(),
    new Tanner(),
    new Drunk(),
    new Minion(),
    new Mason(),
    new Mason(),
    new Doppelganger(),
    new Insomniac(),
        ]
    gameState.readyToStart = false;
    gameState.players = []
    gameState.middles = []
    gameState.votes = {}
    gameState.voted = {}
}
var playOrder = [
            Doppelganger.name,
            Werewolf.name,
            Minion.name,
            Mason.name,
            Seer.name,
            Robber.name,
            Troublemaker.name,
            Drunk.name,
            Insomniac.name,
            Hunter.name,
            Tanner.name,
            Villager.name
        ]
var orderedRoles = [];
var villageTeam = qsTr("You are on <i>village team</i>. Kill at least one werewolf.")

function Villager() {
    this.name = "Villager"
    this.info = villageTeam
    this.desc = qsTr("Villager")
}

function Drunk() {
    this.name = "Drunk"
    this.info = qsTr("You don't know who you are")
    this.desc = qsTr("Drunk")

    this.doRole = function(pl) {
        var rm = Math.floor(Math.random() * 3)
        var m = getMiddle(rm)
        var mr = m.switchedRole || m.role
        if (pl.switchedRole)
        {
            console.log("DoppelDrunk already switched")
            mr = pl.switchedRole
        }

        m.role = pl.role
        pl.role = mr
        console.log("Drunk")
        console.log(pl.title + " is now "+pl.role.name)
        console.log(m.title + " is now "+m.role.name)
    }
}

function Werewolf() {
    this.name = "Werewolf"
    this.info = qsTr("You are on <i>werewolf team</i>. No werewolf must die.")
    this.desc = qsTr("Werewolf")
}
function Seer() {
    this.name = "Seer"
    this.info = villageTeam
    this.desc = qsTr("Seer")
}
function Robber() {
    this.name = "Robber"
    this.switched = null
    this.info = qsTr("You are ...")
    this.desc = qsTr("Robber")

    this.doRole = function(pl) {
        if (!this.switched) return
        var newRole = this.switched.role
        this.switched.role = pl.role
        pl.role = newRole
        console.log("Robber")
        console.log(pl.title + " is now "+pl.role.name)
        console.log(this.switched.title + " is now "+this.switched.role.name)
    }
}
function Troublemaker() {
    this.name = "Troublemaker"
    this.switched = []
    this.info = villageTeam
    this.desc = qsTr("Troublemaker")

    this.doRole = function(pl) {
        if (!this.switched || this.switched.length != 2)
            return
        var a = this.switched[0]
        var b = this.switched[1]
        var ar = a.role
        var br = b.role
        a.role = br
        b.role = ar
        console.log("Troublemaker")
        console.log(a.title + " is now "+a.role.name)
        console.log(b.title + " is now "+b.role.name)
    }
}
function Mason() {
    this.name = "Mason"
    this.logic = "Werewolf"
    this.info = villageTeam
    this.desc = qsTr("Mason")
}
function Minion() {
    this.name = "Minion"
    this.info = qsTr("You are on <i>werewolf team</i>. No werewolf must die, but you can.")
    this.desc = qsTr("Minion")
}
function Tanner() {
    this.name = "Tanner"
    this.logic = "Villager"
    this.info = qsTr("Try to get yourself killed!")
    this.desc = qsTr("Tanner")
}
function Hunter() {
    this.name = "Hunter"
    this.logic = "Villager"
    this.info = qsTr("The player you point at will die. You are on <i>village team</i>")
    this.voted = undefined;
    this.desc = qsTr("Hunter")
}

function Doppelganger() {
    this.name = "Doppelganger"
    this.logic = "Doppelganger"
    this.info = qsTr("You are ...")
    this.desc = qsTr("Doppelganger")

    this.newRole = undefined

    this.doRole = function(pl) {
        if (this.newRole && this.newRole.doRole)
        {
            console.log("Doppelganger - "+this.newRole.name)
            this.newRole.doRole(pl);
        }
    }
}

function Insomniac() {
    this.name = "Insomniac"
    this.logic = "Villager"
    this.info = qsTr("You are awake.")
    this.desc = qsTr("Insomniac")

    this.doRole = function(pl) {
        pl.seeRole = true
    }
}

function Player(id) {
    this.id = id;
    this.title = "P "+(id+1);
    this.role = undefined;
    this.switchedRole = undefined
    this.seeRole = false
}

function Middle(id) {
    this.id = id;
    this.title = "";
    this.role = undefined;
    this.switchedRole = undefined
}

function startGame() {
    var selRols = gameState.selectedRoles.slice();
    /** TESTING **/
    //var pl = new Player(0)
    //pl.role = gameState.roles[selRols.splice(6,1)[0]]
    //gameState.players[0] = pl
    /** END **/
    console.log("DEBG MODE "+gameState.debugMode)
    for (var p = 0; p < gameState.numberOfPlayers; p++)
    {
        var desiredIndex = Math.floor(Math.random() * selRols.length);
        if (gameState.debugMode && !gameState.debugRandomize) desiredIndex = 0
        var roleInd = selRols.splice(desiredIndex, 1)[0];
        var pl = new Player(p)
        pl.title = gameState.playerNames[p]
        pl.role = gameState.roles[roleInd];
        gameState.players[p] = pl;
        gameState.votes[pl.id] = 0;
    }
    for (var s = 0; s < 3; s++)
    {
        var desiredIndex = Math.floor(Math.random() * selRols.length);
        var roleInd = selRols.splice(desiredIndex, 1)[0];
        var pl = new Middle(s)
        pl.role = gameState.roles[roleInd];
        gameState.middles.push(pl);
    }

    orderedRoles = gameState.selectedRoles.sort(function (ra, rb) {
        var rola = gameState.roles[ra];
        var rolb = gameState.roles[rb];
        return playOrder.indexOf(rola.name) -
                playOrder.indexOf(rolb.name);
       });
}

function getPlayer(id) {
    return gameState.players[id];
}

function getPlayers(roleType, originals)
{
    var ret = []
    for (var p in gameState.players)
    {
        if (gameState.players[p].role instanceof roleType)
            ret.push(gameState.players[p])
        if (!originals && gameState.players[p].role.newRole instanceof roleType)
            ret.push(gameState.players[p])
    }
    /*
    for (var m in gameState.middles)
        if (gameState.middles[m].role instanceof roleType)
            ret.push(gameState.middles[m])
            */
    return ret;
}

function getMiddle(id) {
    return gameState.middles[id];
}

function readyToStart() {
    var roles = gameState.selectedRoles.length
    gameState.readyToStart = gameState.numberOfPlayers + 3 == roles;
    return gameState.readyToStart;
}

function calcFinalRoles()
{
    console.log("Calculating final roles")
    var roles = [Doppelganger, Robber, Troublemaker, Drunk, Insomniac]
    var players = []
    for (var r in roles)
    {
        var pl = getPlayers(roles[r], true)[0]
        players.push(pl)
        if (pl)
        {
            console.log(pl.role.name)
            roles[r] = pl.role
        }
        else
            roles[r] = undefined
    }

    while (roles.length)
    {
        var role = roles.shift()
        var pl = players.shift()
        if (role)
        {
            console.log("try "+role.name+" with "+pl.title)
            role.doRole(pl)
        }
    }
}

function vote(voter, voted)
{
    gameState.voted[voter.id] = voted.id
    gameState.votes[voted.id]++;
    if (voter.role instanceof Hunter || voter.role.newRole instanceof Hunter)
    {
        var v = gameState.votes[voted.id]
        gameState.votes[voted.id] = (v % 900) + 900
    }
    console.log(voter.title + " voted for "+voted.title)
}

function addRoles(list) {
    for (var r in gameState.roles)
        list.append(gameState.roles[r]);
    readyToStart()
}

function isSelected(index)  {
    return gameState.selectedRoles.indexOf(index) > -1;
}

function isRoleIn(role) {
    for (var r in gameState.selectedRoles)
    {
        if (gameState.roles[gameState.selectedRoles[r]] instanceof role)
            return true
    }
    return false
}

function getRoleOrdered(index) {
    var order_pl = {};
    order_pl.role = gameState.roles[orderedRoles[index]];
    return order_pl;
}

function toggleRole(index) {
    var roles = gameState.selectedRoles.length
    if (isSelected(index))
        gameState.selectedRoles.splice(gameState.selectedRoles.indexOf(index), 1);
    else if (roles < gameState.numberOfPlayers + 3)
        gameState.selectedRoles.push(index);
    readyToStart();
}
