/*
Author:
Nicholas Clark (SENSEI)

Description:
select task to spawn, this function must be spawned

Arguments:
0: task type <NUMBER>
1: if task should run after cooldown <BOOL>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [["_type",1],["_cooldown",-1]];

if (_cooldown < 0) then {
	sleep GVAR(cooldown);
} else {
	sleep _cooldown;
};

// primary task
if (_type > 0) then {
	GVAR(primary) = selectRandom GVAR(primaryTasks);
	if !(isNil QGVAR(primary)) then {
		[] spawn (missionNamespace getVariable [GVAR(primary),{}]);
	};
} else {
	// secondary task
	GVAR(secondary) = selectRandom GVAR(secondaryTasks);
	if !(isNil QGVAR(secondary)) then {
		[] spawn (missionNamespace getVariable [GVAR(secondary),{}]);
	};
};