/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_data"];

if !(_data isEqualTo []) then {
	[_data select 0,_data select 1] call FUNC(handleCreate);
	{
		_veh = (_x select 0) createVehicle [0,0,0];
		_veh setDir (_x select 2);
		_veh setPosASL (_x select 1);
		_veh setVectorUp (_x select 3);
		GVAR(curator) addCuratorEditableObjects [[_veh],false];
		false
	} count (_data select 2);
};
