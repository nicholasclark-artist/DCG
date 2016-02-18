/*
Author:
Nicholas Clark (SENSEI)

Description:
handles animal unit spawns

Arguments:
0: positions to watch for animal spawns <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define ZDIST 65

[{
	private ["_pos","_str"];
	params ["_args","_idPFH"];
	_args params ["_posArray"];

	{
		if !(missionNamespace getVariable [format ["%1_%2", QUOTE(ADDON),_x select 0],false]) then {
			_pos = _x select 0;
			_str = _x select 1;

			if ({CHECK_DIST2D((vehicle _x),_pos,GVAR(spawnDist)) && {((getPosATL (vehicle _x)) select 2) < ZDIST}} count allPlayers > 0) then {
				[_pos,_str] spawn FUNC(spawnAnimal);
			};
		};
	} forEach _posArray;
}, 15, [_this select 0]] call CBA_fnc_addPerFrameHandler;