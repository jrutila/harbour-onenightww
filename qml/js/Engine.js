.pragma library
var gameState
function getGame() {
    return gameState;
}

function initGameState(st) {
    console.log("initing gamestate")
    gameState = st;
    gameState.roles =[
    new Doppelganger(),
    new Seer(),
    new Robber(),
    new Troublemaker(),
    new Drunk(),
    new Werewolf(),
    new Minion(),
    new Werewolf(),
    new Villager(),
    new Villager(),
    new Villager(),
    new Mason(),
    new Mason(),
    new Hunter(),
    new Tanner(),


    new Insomniac(),
        ]
    gameState.readyToStart = false;
    gameState.players = []
    gameState.middles = []
    gameState.votes = {}
    gameState.voted = {}
}
var villageTeam = "You are on <i>village team</i>. Kill at least one werewolf."

function Villager() {
    this.name = "Villager"
    this.info = villageTeam
}

function Drunk() {
    this.name = "Drunk"
    this.info = "You don't know who you are"

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

function Doppelganger() {
    this.name = "Doppelganger"
    this.logic = "Doppelganger"
    this.info = "You are ..."
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
    this.logic = "Insomniac"
    this.info = "You are awake"
}

function Player(id) {
    this.id = id;
    this.title = "P "+(id+1);
    this.role = undefined;
    this.switchedRole = undefined
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
    for (var p = 0; p < gameState.numberOfPlayers; p++)
    {
        var desiredIndex = Math.floor(Math.random() * selRols.length);
        //var desiredIndex = 0
        var roleInd = selRols.splice(desiredIndex, 1)[0];
        var pl = new Player(p)
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
    var roles = [Doppelganger, Robber, Troublemaker, Drunk]
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

function toggleRole(index) {
    var roles = gameState.selectedRoles.length
    if (isSelected(index))
        gameState.selectedRoles.splice(gameState.selectedRoles.indexOf(index), 1);
    else if (roles < gameState.numberOfPlayers + 3)
        gameState.selectedRoles.push(index);
    readyToStart();
}
