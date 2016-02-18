/*
Author:
Nicholas Clark (SENSEI)

Description:
select task to spawn, this function must be spawned

Arguments:
0: task type <NUMBER>
1: cooldown before spawning task. if number is less than zero, cooldown set in serverSettings will be used <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_task"];
params [["_type",1],["_cooldown",-1]];

if (_cooldown < 0) then {
	sleep GVAR(cooldown);
} else {
	sleep _cooldown;
};

// primary task
if (_type > 0) then {
	_task = selectRandom GVAR(primaryTasks);
	if !(isNil "_task") then {
		[] spawn (missionNamespace getVariable [_task,{}]);
	};
} else {
	// secondary task
	_task = selectRandom GVAR(secondaryTasks);
	if !(isNil "_task") then {
		[] spawn (missionNamespace getVariable [_task,{}]);
	};
};