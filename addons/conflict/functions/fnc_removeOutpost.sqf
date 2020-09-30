/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_key","",[""]],
    ["_force",false,[false]]
];

private _value = [GVAR(outposts),_key] call CBA_fnc_hashGet;

// remove from hash
[GVAR(areas),_key] call CBA_fnc_hashRem;

// force arg will immediately remove all units and tasks
if (_force) then {
    (_value getVariable [QGVAR(groups),[]]) call CBA_fnc_deleteEntity;
    (_value getVariable [QGVAR(intel),objNull]) call CBA_fnc_deleteEntity;
    [_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;
} else {
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(intel),objNull]] call CBA_fnc_localEvent;
    [_value getVariable [QGVAR(task),""],"SUCCEEDED"] call BIS_fnc_taskSetState;
};

// reset vars
_value setVariable [QGVAR(status),false];
_value setVariable [QGVAR(intelStatus),false];
_value setVariable [QGVAR(intel),objNull];
_value setVariable [QGVAR(task),""];
_value setVariable [QGVAR(composition),[]];
_value setVariable [QGVAR(nodes),[]];
_value setVariable [QGVAR(groups),[]];

INFO_1("removed outpost: %1",_key);

nil