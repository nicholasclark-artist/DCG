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

[GVAR(outposts),{
    // cleanup
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(composition),[]]] call CBA_fnc_localEvent;
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;
 
    // remove tasks 
    [_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;

    // remove location without delay
    _value call CBA_fnc_deleteEntity;
}] call CBA_fnc_hashEachPair;

[GVAR(comms),{
    // cleanup
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(composition),[]]] call CBA_fnc_localEvent;
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;

    // remove location without delay
    _value call CBA_fnc_deleteEntity;
}] call CBA_fnc_hashEachPair;

[GVAR(garrisons),{
    // cleanup
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(composition),[]]] call CBA_fnc_localEvent;
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;
 
    // remove tasks 
    [_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;

    // remove location without delay
    _value call CBA_fnc_deleteEntity;
}] call CBA_fnc_hashEachPair;

[GVAR(areas),{
    // cleanup
    [QEGVAR(main,cleanup),_value getVariable [QGVAR(groups),[]]] call CBA_fnc_localEvent;
    
    // remove map polygons
    [
        [],
        {
            {
                (findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",_x];
            } forEach GVAR(polygonDraw); 
        }
    ] remoteExecCall [QUOTE(call),0,false];

    // remove tasks 
    [_value getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;

    // remove vars
    _value setVariable [QGVAR(status),nil];
    _value setVariable [QGVAR(name),nil];
    _value setVariable [QGVAR(task),nil];
    _value setVariable [QGVAR(groups),nil];
    _value setVariable [QGVAR(patrolPositions),nil];
}] call CBA_fnc_hashEachPair;

// reset score
GVAR(score) = 0;

// remove hashes
GVAR(outposts) = nil;
GVAR(garrisons) = nil;
GVAR(comms) = nil;
GVAR(areas) = nil;

nil