/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_data"];

if !(_data isEqualTo []) then {
	_data params ["_primary","_secondary"];

	if !(_primary isEqualTo []) then {
		[_primary select 1] spawn (missionNamespace getVariable [_primary select 0,{}]);
	} else {
		[1,0] call FUNC(select);
	};

	if !(_secondary isEqualTo []) then {
		[_secondary select 1] spawn (missionNamespace getVariable [_secondary select 0,{}]);
	} else {
		[0,10] call FUNC(select);
	};
} else {
	[1,0] call FUNC(select);
	[0,10] call FUNC(select);
};