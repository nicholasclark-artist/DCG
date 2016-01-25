/*
Author: Nicholas Clark (SENSEI)

Description:
sets civilians task

Arguments:

Return:
none
__________________________________________________________________*/
// TODO: Test running tasks in scheduled and non scheduled environment. Non scheduled seems to cause client lag

if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_override","_task"];

_override = param [0,"",[""]];

DCG_taskSuccess = 0;
DCG_taskCounterCiv = DCG_taskCounterCiv + 1;

if !(_override isEqualTo "") exitWith {
	if (toLower _override isEqualTo "rebel") then {
		[{
			params ["_args","_idPFH"];
			_args params ["_time"];

			if (diag_tickTime > _time) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				_task = "DCG_fnc_taskRebelCiv";
				[] spawn (missionNamespace getVariable [_task,{}]);
				["Task: %1.", _task] call DCG_fnc_log;
			};
		}, 1, [diag_tickTime + 1800]] call CBA_fnc_addPerFrameHandler;
	} else {
		_override = format ["DCG_fnc_task%1Civ",_override];
		[] spawn (missionNamespace getVariable [_override,{}]);
		["Task, override: %1.", _override] call DCG_fnc_log;
	};
};

[{
	params ["_args","_idPFH"];
	_args params ["_time"];

	if (diag_tickTime > _time) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_task = DCG_taskListCiv select floor (random (count DCG_taskListCiv));
		_task = format ["DCG_fnc_task%1Civ",_task];
		[] spawn (missionNamespace getVariable [_task,{}]);
		["Task: %1.", _task] call DCG_fnc_log;
	};
}, 1, [diag_tickTime + TASKCIV_COOLDOWN]] call CBA_fnc_addPerFrameHandler;
