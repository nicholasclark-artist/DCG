/*
Author:
Nicholas Clark (SENSEI)

Description:
eventhandler for cached group's leader

Arguments:
0: leader of cached group <OBJECT>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

private ["_ret","_grp"];
params ["_leader"];

_ret = _leader addEventHandler ["killed", {
	if (count units group (_this select 0) >= 2) then {
		[_this select 0] spawn {
			_grp = group (_this select 0);
			waitUntil {!((leader _grp) isEqualTo (_this select 0))};
			_leader = leader _grp;
			[_leader] call FUNC(uncache);
			[_leader] call FUNC(leaderEH);
		};
	};
}];

_ret