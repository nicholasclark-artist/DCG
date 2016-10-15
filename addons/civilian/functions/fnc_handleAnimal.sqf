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

_args = _this select 0;

{
	if !(missionNamespace getVariable [LOCATION_ID(_x select 0),false]) then {
		_x params ["_pos","_types"];

		_near = _pos nearEntities [["Man", "LandVehicle"], GVAR(spawnDist)];
		_near = _near select {isPlayer _x && {(getPosATL _x select 2) < ZDIST}};

		if !(_near isEqualTo []) then {
			[_pos,_types] call FUNC(spawnAnimal);
		};
	};

	false
} count (_args select 0);