/*
Author:
Nicholas Clark (SENSEI)

Description:
spawns animals

Arguments:
0: position to spawn <ARRAY>
1: types to spawn <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_pos","_types"];

private _agentList = [];
private _id = str _pos;

missionNamespace setVariable [LOCATION_ID(_id),true];

for "_i" from 1 to 10 do {
	private _agent = createAgent [selectRandom _types, _pos, [], 150, "NONE"];
	_agentList pushBack _agent;
};

[{
	params ["_args","_idPFH"];
	_args params ["_pos","_agentList"];

	if (([_pos,GVAR(spawnDist),ZDIST] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
        _agentList call EFUNC(main,cleanup);
		missionNamespace setVariable [LOCATION_ID(_id),false];
	};
}, HANDLER_DELAY, [_pos,_agentList]] call CBA_fnc_addPerFrameHandler;
