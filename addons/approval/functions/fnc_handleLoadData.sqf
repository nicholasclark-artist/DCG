/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading addon data

Arguments:
0: loaded data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_data"];

if !(_data isEqualTo []) then {
	{
		missionNamespace setVariable [AV_LOCATION_ID(_x select 0),_x select 1,false];
		false
	} count _data;
} else {
	{
		missionNamespace setVariable [AV_LOCATION_ID(_x select 0),AV_MAX*0.1,false];
		false
	} count EGVAR(main,locations);
};