/*
Author:
Nicholas Clark (SENSEI)

Description:
set units on patrol

Arguments:
0: group <GROUP>
1: patrol center position <ARRAY>
2: max patrol distance <NUMBER>
3: code to run on waypoint completion <STRING>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_grp",grpNull,[grpNull]],
    ["_center",[0,0,0],[[]]],
    ["_radius",50,[0]],
    ["_onComplete","",[""]]
];

if !(local _grp) exitWith {
    WARNING_1("Cannot set patrol for non local group, %1",_grp);
    false
};

if ((objectParent leader _grp) isKindOf "Air") exitWith {
    [_grp] call CBA_fnc_clearWaypoints;
    private _waypoint = _grp addWaypoint [_center,0];
    _waypoint setWaypointType "LOITER";
    _waypoint setWaypointLoiterRadius _radius;
    _waypoint setWaypointLoiterType "CIRCLE";
    _waypoint setWaypointSpeed "NORMAL";
    _waypoint setWaypointBehaviour "SAFE";
    _waypoint setWaypointStatements ["true", _onComplete];
};

[_grp, _center, _radius, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", _onComplete, [0,5,10]] call CBA_fnc_taskPatrol;

true
