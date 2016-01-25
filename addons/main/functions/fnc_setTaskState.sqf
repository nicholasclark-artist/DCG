/*
Author: SENSEI

Last modified: 1/9/2016

Description: set task state

Return: nothing
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