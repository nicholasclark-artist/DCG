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

params ["_leader"];

_leader setVariable [QUOTE(DOUBLES(ADDON,leaderHasEH)),true];

// if leader is killed, setup new leader
_leader addEventHandler ["killed", {
	if (group (_this select 0) in GVAR(groups) && {leader (_this select 0) isEqualTo (_this select 0)} && {count units group (_this select 0) >= 2}) then {
		[_this select 0] spawn {
			_grp = group (_this select 0);
			waitUntil {!((leader _grp) isEqualTo (_this select 0))};
			_leader = leader _grp;
			[_leader] call FUNC(uncache);
			[_leader] call FUNC(leaderEH);
		};
	};
}];

// if leader exits vehicle while group is cached, move group out of vehicle and move to leader
if !((vehicle _leader) isEqualTo _leader) then {
	(vehicle _leader) addEventHandler ["GetOut", {
		if (group (_this select 2) in GVAR(groups)) then {
			group (_this select 2) leaveVehicle (_this select 0);
		};
	}];
};
