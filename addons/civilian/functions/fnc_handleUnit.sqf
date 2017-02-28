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

{
    _x params ["_name","_position","_size","_type"];

	if (!(missionNamespace getVariable [LOCATION_ID(_name),false]) && {GVAR(blacklist) find _name isEqualTo -1}) then {
        _players = [ASLToAGL _position,GVAR(spawnDist),ZDIST] call EFUNC(main,getNearPlayers);

		if !(_players isEqualTo []) then {
            private "_unitCount";

			call {
				if (_type isEqualTo "NameVillage") exitWith {
					_unitCount = ceil(5*GVAR(multiplier));
				};
				if (_type isEqualTo "NameCity") exitWith {
					_unitCount = ceil(10*GVAR(multiplier));
				};
                _unitCount = ceil(15*GVAR(multiplier));
			};

			[ASLToAGL _position,_unitCount,_name,_size] call FUNC(spawnUnit);
		};
	};

	false
} count (_this select 0);
