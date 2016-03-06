/*
Author:
Nicholas Clark (SENSEI)

Description:
eventhandler for cached group's leader

Arguments:
0: leader of cached group <OBJECT>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define LEADER_EH QUOTE(DOUBLES(ADDON,leaderHasEH))
#define UNIT_EH QUOTE(DOUBLES(ADDON,UnitHasEH))

params ["_unit"];

if (_unit isEqualTo leader _unit && {!(_unit getVariable [LEADER_EH,false])}) exitWith {
	_unit setVariable [LEADER_EH,true];

	// if leader is killed, setup new leader
	_unit addEventHandler ["killed", {
		if (group (_this select 0) in GVAR(groups) && {leader (_this select 0) isEqualTo (_this select 0)} && {count units group (_this select 0) >= 2}) then {
			[_this select 0] spawn {
				_grp = group (_this select 0);
				waitUntil {!((leader _grp) isEqualTo (_this select 0))};
				_unit = leader _grp;
				[_unit] call FUNC(uncache);
				[_unit] call FUNC(addEventhandler);
			};
		};
	}];

	// if leader exits vehicle while group is cached, move group out of vehicle and move to leader
	if !((vehicle _unit) isEqualTo _unit) then {
		(vehicle _unit) addEventHandler ["GetOut", {
			if (group (_this select 2) in GVAR(groups)) then {
				group (_this select 2) leaveVehicle (_this select 0);
			};
		}];
	};
};

if !(_unit getVariable [UNIT_EH,false]) exitWith {
	_unit setVariable [UNIT_EH,true];
	_unit addEventHandler ["killed", {
		[_this select 0] call FUNC(uncache);
	}];
};