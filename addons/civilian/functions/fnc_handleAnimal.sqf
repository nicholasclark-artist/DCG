/*
Author:
Nicholas Clark (SENSEI)

Description:
handles animal unit spawns

Arguments:
0: positions and animal classes <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

{
	if !(missionNamespace getVariable [LOCATION_ID(_x select 0),false]) then {
		_x params ["_pos","_types"];

		_players = [ASLtoAGL _pos,GVAR(spawnDist),ZDIST] call EFUNC(main,getNearPlayers);

		if !(_players isEqualTo []) then {
			[ASLtoAGL _pos,_types] call FUNC(spawnAnimal);
		};
	};

	false
} count (_this select 0);
