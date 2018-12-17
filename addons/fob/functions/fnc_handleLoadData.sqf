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

if !(_this isEqualTo []) then {
	[_this select 0,_this select 1] call FUNC(handleCreate);
	{
		_veh = (_x select 0) createVehicle [0,0,0];
		_veh setDir (_x select 2);
		_veh setPosASL (_x select 1);
		_veh setVectorUp (_x select 3);
		GVAR(curator) addCuratorEditableObjects [[_veh],false];
		false
	} count (_this select 2);
};
