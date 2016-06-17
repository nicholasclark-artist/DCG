/*
Author:
Nicholas Clark (SENSEI)

Description:
add approval value to region

Arguments:
0: center position <ARRAY>
1: value <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private ["_locations","_value"];
params ["_position","_add"];

_locations = [_position] call FUNC(getRegion);
LOG_DEBUG_1("%1",_this);
{
	_value = missionNamespace getVariable [AV_VAR(_x select 0),0];
	missionNamespace setVariable [AV_VAR(_x select 0),_value + _add];
	false
} count _locations;