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

params ["_position","_add"];

{
	private _value = missionNamespace getVariable [AV_LOCATION_ID(_x select 0),0];
	missionNamespace setVariable [AV_LOCATION_ID(_x select 0),_value + _add];

	LOCATION_DEBUG_ID(_x select 0) setMarkerText LOCATION_DEBUG_TEXT(_x select 0);
	// INFO_3("Location: %1, added value: %2, current value: %3",_x select 0,_add,_value + _add);

	false
} count ([_position] call FUNC(getRegion));
