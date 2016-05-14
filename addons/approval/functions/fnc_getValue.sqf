/*
Author:
Nicholas Clark (SENSEI)

Description:
get approval value for region

Arguments:
0: center position <ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private ["_value","_locations"];

_value = -1;
_locations = [_this select 0] call FUNC(getRegion);

{
	_value = _value + (missionNamespace getVariable [AV_VAR(_x select 0),0]);
	false
} count _locations;

if (_value < 0 || {_locations isEqualTo []}) exitWith {-1};

_value = _value*(1/(count _locations));

_value