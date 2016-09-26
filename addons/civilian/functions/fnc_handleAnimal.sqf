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

[{
	params ["_args","_idPFH"];
	_args params ["_posArray"];

	{
		if !(GET_LOCVAR(_x select 0)) then {
			private _pos = _x select 0;
			private _str = _x select 1;

			private _near = _pos nearEntities [["Man", "LandVehicle"], GVAR(spawnDist)];
			_near = _near select {isPlayer _x && {(getPosATL _x select 2) < ZDIST}};

			if !(_near isEqualTo []) then {
				[_pos,_str] call FUNC(spawnAnimal);
			};
		};
	} forEach _posArray;
}, 15, [_this select 0]] call CBA_fnc_addPerFrameHandler;