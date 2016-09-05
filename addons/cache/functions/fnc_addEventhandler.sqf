/*
Author:
Nicholas Clark (SENSEI)

Description:
add caching eventhandlers to units

Arguments:
0: unit <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_unit"];

if (_unit isEqualTo leader _unit && {!(_unit getVariable [UNIT_EH,false])}) exitWith {
	_unit setVariable [UNIT_EH,true];

	// if leader is killed, setup new leader
	_unit addEventHandler ["killed", {
		if (group (_this select 0) in GVAR(groups) && {leader (_this select 0) isEqualTo (_this select 0)} && {count units group (_this select 0) >= 2}) then {
			[
				{!((leader (_this select 0)) isEqualTo (_this select 1))},
				{
					_newLeader = leader (_this select 0);
					[_newLeader] call FUNC(uncache);
					[_newLeader] call FUNC(addEventhandler);
				},
				[group (_this select 0),_this select 0]
			] call CBA_fnc_waitUntilAndExecute;
		};
	}];

	// if leader exits vehicle while group is cached, move group out of vehicle
	if !(isNull objectParent _unit) then {
		(objectParent _unit) addEventHandler ["GetOut", {
			if (group (_this select 2) in GVAR(groups)) then {
				group (_this select 2) leaveVehicle (_this select 0);
			};
		}];
	};
};

if !(_unit getVariable [UNIT_EH,false]) then {
	_unit setVariable [UNIT_EH,true];
	_unit addEventHandler ["killed", {
		[_this select 0] call FUNC(uncache);
	}];
};