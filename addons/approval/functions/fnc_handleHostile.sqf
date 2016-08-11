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

[{
	_HCs = entities "HeadlessClient_F";
	_players = allPlayers - _HCs;
	_player = selectRandom _players;
	_pos = getPos _player;

	if (!(CHECK_DIST2D(_pos,locationPosition GVAR(baseLocation),GVAR(baseRadius))) && {alive _player}) then {
		if (random 1 < AV_CHANCE(_pos)) then {
			[_player] call FUNC(spawnHostile);
		};
	};
}, GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;