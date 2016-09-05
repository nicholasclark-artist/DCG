/*
Author:
Nicholas Clark (SENSEI)

Description:
waypoint position PFH

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_grp","_wp","_target",["_interval",15]];

if (typeName _target isEqualTo "ARRAY") exitWith { // if _target is position exit with simple set position
	_wp setWaypointPosition [_target, 0];
};

[{
	params ["_args","_idPFH"];
	_args params ["_grp","_wp","_target"];

	if (isNull _grp) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};
	_wp setWaypointPosition [getPosATL _target, 0];
}, _interval, [_grp,_wp,_target]] call CBA_fnc_addPerFrameHandler;