/*
Author:
Nicholas Clark (SENSEI)

Description:
spawns animals

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_agentArray","_type","_agent"];
params ["_pos","_expression","_dist"];

missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_pos],true];
_agentArray = [];
_type = "";
_count = 0;

call {
	if (_expression isEqualTo "hills") exitWith {
		_type = "Goat_random_F";
		_count = 15;
	};
	if (_expression isEqualTo "houses") exitWith {
		_type = "Fin_random_F";
		_count = 5;
	};
	if (_expression isEqualTo "forest") exitWith {
		_type = "Goat_random_F";
		_count = 15;
	};

	_type = "Sheep_random_F";
	_count = 15;
};

for "_i" from 0 to (_count - 1) do {
	_agent = createAgent [_type, _pos, [], 150, "NONE"];
	_agentArray pushBack _agent;
};

[{
	params ["_args","_idPFH"];
	_args params ["_pos","_dist","_agentArray"];

	if ({_x distance _pos < _dist} count allPlayers isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		missionNamespace setVariable [format ["%1_%2",QUOTE(ADDON),_pos],false];
		_agentArray call EFUNC(main,cleanup);
	};
}, 30, [_pos,_dist,_agentArray]] call CBA_fnc_addPerFrameHandler;