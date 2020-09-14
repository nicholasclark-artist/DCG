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
    ["_value",locationNull,[locationNull]]
];

// remove units and composition
[QEGVAR(main,cleanup),_value getVariable [QGVAR(composition),[]]] call CBA_fnc_localEvent;
[QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;

// remove tasks
[_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;

// remove intel
[QEGVAR(main,cleanup),_value getVariable [QGVAR(intel),objNull]] call CBA_fnc_localEvent;

INFO_1("removed outpost: %1",_key);

_value call CBA_fnc_deleteEntity;

nil