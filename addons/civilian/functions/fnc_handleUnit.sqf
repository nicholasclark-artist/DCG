/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns

Arguments:
0: positions to watch for civ spawns <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[{
	params ["_args","_idPFH"];
	_args params ["_locations"];
	{
		if (!(GET_LOCVAR(_x select 0)) && {GVAR(blacklist) find (_x select 0) isEqualTo -1}) then {
			private ["_unitCount"];
			private _position = _x select 1;

			private _near = _position nearEntities [["Man", "LandVehicle"], GVAR(spawnDist)];
			_near = _near select {isPlayer _x && {(getPosATL _x select 2) < ZDIST}};

			if !(_near isEqualTo []) then {
				call {
					if ((_x select 3) isEqualTo "NameCityCapital") exitWith {
						_unitCount = ceil(GVAR(countCapital));
					};
					if ((_x select 3) isEqualTo "NameCity") exitWith {
						_unitCount = ceil(GVAR(countCity));
					};
					_unitCount = ceil(GVAR(countVillage));
				};
				[ASLToAGL _position,_unitCount,_x select 0] call FUNC(spawnUnit);
			};
		};
	} forEach _locations;
}, 15, [_this select 0]] call CBA_fnc_addPerFrameHandler;