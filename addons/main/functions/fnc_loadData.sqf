/*
Author:
Nicholas Clark (SENSEI)

Description:
check server profile for saved data and assign it for current scenario

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

{
	if (toUpper (_x select 0) isEqualTo SAVE_SCENARIO_ID) exitWith {
		GVAR(saveDataCurrent) = _x;
	};
} forEach (SAVE_GET_VAR);
