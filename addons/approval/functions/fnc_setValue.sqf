/*
Author:
Nicholas Clark (SENSEI)

Description:
add approval value to locations around position

Arguments:
0: center position <ARRAY>
1: value <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private ["_locations","_valueOld"];
params ["_position","_value"];

_locations = [_position] call FUNC(getRegion);

{
	_valueOld = missionNamespace getVariable [AV_VAR(_x select 0),0];
	missionNamespace setVariable [AV_VAR(_x select 0),_valueOld + _value];
	false
} count _locations;