/*
Author:
Nicholas Clark (SENSEI)

Description:
set task

Arguments:
0: environment where function will run <NUMBER,OBJECT,SIDE,GROUP,ARRAY,BOOL>
1: task id <STRING>
2: task description <ARRAY>
3: task position <ARRAY>
4: set as current task <BOOL>
5: show task notification <BOOL>
6: task type defined in CfgTaskTypes <STRING>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_target",objNull],
    ["_id",""],
    ["_desc",["task description","task title",""]],
    ["_pos",[0,0,0]],
    ["_state",false],
    ["_hint",true],
    ["_type","Default"]
];

if (getNumber (missionConfigFile >> "CfgTaskEnhancements" >> "enable") isEqualTo 1) then { // new task system
    [_target,_id,_desc,_pos,_state,0,_hint,_type] call BIS_fnc_taskCreate;
} else { // old task system
    if (_target isEqualTo true) then {
        _target = 0;
    };
    if (_id isEqualType "") then {
        _id = [_id];
    };

    [[_id,_desc,_pos],{
        if (hasInterface) then {
            _task = player createSimpleTask (_this select 0);
            _task setSimpleTaskDescription [(_this select 1) select 0, (_this select 1) select 1, (_this select 1) select 2];
            if (!((_this select 2) isEqualTo [0,0,0]) && {!((_this select 2) isEqualTo [])}) then {
                _task setSimpleTaskDestination (_this select 2);
            };
            _task setTaskState "Assigned";
        };
    }] remoteExecCall ["BIS_fnc_call",_target,true];
};

true