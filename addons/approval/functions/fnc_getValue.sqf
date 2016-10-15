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

_value = 0;
_locations = [_this select 0] call FUNC(getRegion);

{
	_value = _value + (missionNamespace getVariable [AV_LOCATION_ID(_x select 0),0]);
	false
} count _locations;

_value = _value*(1/((count _locations) max 1));

_value