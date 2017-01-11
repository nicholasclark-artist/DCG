/*
Author:
Nicholas Clark (SENSEI)

Description:
handle hostile unit spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _HCs = entities "HeadlessClient_F";
private _players = allPlayers - _HCs;
private _player = selectRandom _players;
private _pos = getPos _player;

if (!(_pos inArea EGVAR(main,baseLocation)) && {alive _player}) then {
	if (random 1 < AV_CHANCE(_pos)) then {
		[_player] call FUNC(spawnHostile);
	};
};
