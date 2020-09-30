/*
Author:
Nicholas Clark (SENSEI)

Description:
remove area of operations on server

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

private _value = [GVAR(areas),_key] call CBA_fnc_hashGet;

// remove from hash
[GVAR(areas),_key] call CBA_fnc_hashRem;

// force arg will immediately remove all units and tasks
if (_force) then {
    (_value getVariable [QGVAR(groups),[]]) call CBA_fnc_deleteEntity;
    [_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;
} else {
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;
    [_value getVariable [QGVAR(task),""],"SUCCEEDED"] call BIS_fnc_taskSetState;
};

// remove map polygon
[
    _key,
    {
        {
            (findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",_x];
        } forEach (missionNamespace getVariable [AO_POLY_ID(_this),[]]);
    }
] remoteExecCall [QUOTE(call),0,false];

// reset vars
_value setVariable [QGVAR(status),false];
_value setVariable [QGVAR(task),""];
_value setVariable [QGVAR(groups),[]];

INFO_1("removed area: %1",_key);

nil