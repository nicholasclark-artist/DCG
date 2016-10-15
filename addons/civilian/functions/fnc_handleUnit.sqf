/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian unit spawns

Arguments:
0: location array <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

_args = _this select 0;

{
	if (!(missionNamespace getVariable [LOCATION_ID(_x select 0),false]) && {GVAR(blacklist) find (_x select 0) isEqualTo -1}) then {
		private "_unitCount";
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

	false
} count (_args select 0);