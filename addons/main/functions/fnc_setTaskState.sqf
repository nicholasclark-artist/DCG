/*
Author:
Nicholas Clark (SENSEI)

Description:
set task state

Arguments:
0: task id <STRING>
1: state task will be set to <STRING>
2: environment where function will run <NUMBER,OBJECT,SIDE,GROUP,ARRAY>

Return:
none
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
    [[_id,_state],{
        (_this select 0) setTaskState (_this select 1);
    }] remoteExecCall ["BIS_fnc_call",_target,true];
};