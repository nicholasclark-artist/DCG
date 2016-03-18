/*
Author:
Nicholas Clark (SENSEI)

Description:
set task state

Arguments:
0: task id <STRING,TASK>
1: state task will be set to <STRING>
2: environment where function will run <NUMBER,OBJECT,SIDE,GROUP,ARRAY,BOOL>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_id",""],
    ["_state","Succeeded"],
    ["_target",0]
];

if (getNumber (missionConfigFile >> "CfgTaskEnhancements" >> "enable") isEqualTo 1) then { // new task system
    [_id,_state,true] call BIS_fnc_taskSetState;
} else { // old task system
    if (_target isEqualTo true) then {
        _target = 0;
    };
    [[_id,_state],{
    	if (hasInterface && {(_this select 0) isEqualType ""}) then {
	    	{
				if (str _x find (_this select 0) > -1) then {
					_x setTaskState (_this select 1);
				};
				false
	    	} count (simpleTasks player);
    	};
    }] remoteExecCall ["BIS_fnc_call",_target,true];
};

true