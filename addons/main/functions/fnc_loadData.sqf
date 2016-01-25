/*
Author: Nicholas Clark (SENSEI)

Description:
load data from server profile

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

private ["_dataProfile"];

_dataProfile = DATA_GETVAR;

{
	if ((_x select 0) isEqualTo DATA_MISSION_ID) exitWith {
		GVAR(saveDataCurrent) = _x;
	};
} forEach _dataProfile;