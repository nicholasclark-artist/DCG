/*
Author:
Nicholas Clark (SENSEI)

Description:
sets task

Arguments:

Return:
none
__________________________________________________________________*/
// TODO Test running tasks in scheduled and non scheduled environment. Non scheduled seems to cause client lag
#include "script_component.hpp"

if !(isServer) exitWith {};

private ["_override","_task"];

_override = param [0,"",[""]];

DCG_taskSuccess = 0;

if !(_override isEqualTo "") exitWith {
	_override = format ["DCG_fnc_task%1",_override];
	[] spawn (missionNamespace getVariable [_override,{}]);
	["Task, override: %1.", _override] call DCG_fnc_log;
};

if (DCG_taskList isEqualTo []) exitWith {
	DCG_taskList = [
		"defend",
		"defuse",
		"vip",
		"cache",
		"arty",
		"repair",
		"steal"
	];
	_locations = call DCG_fnc_findLocation;
	if !(isNil {HEADLESSCLIENT}) then {
		{
			_x remoteExec ["DCG_fnc_setOccupied", owner HEADLESSCLIENT, false];
			["Spawning occupied location on headless client."] call DCG_fnc_log;
		} forEach _locations;
	} else {
		{
			_x spawn DCG_fnc_setOccupied;
			["Spawning occupied location on server."] call DCG_fnc_log;
		} forEach _locations;
	};
	call DCG_fnc_taskOfficer;
};

_task = DCG_taskList select floor (random (count DCG_taskList));
DCG_taskList = DCG_taskList - [_task];
_task = format ["DCG_fnc_task%1",_task];
[] spawn (missionNamespace getVariable [_task,{}]);
["Task: %1.", _task] call DCG_fnc_log;