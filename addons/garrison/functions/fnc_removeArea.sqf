/*
Author:
Nicholas Clark (SENSEI)

Description:
remove area of operations on server

Arguments:

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {false};

[GVAR(areas),{
    _outpost = [GVAR(outposts),_key] call CBA_fnc_hashGet;
    _garrison = [GVAR(garrisons),_key] call CBA_fnc_hashGet;
    _comms = [GVAR(comms),_key] call CBA_fnc_hashGet;
    
    // cleanup compositions
    [QEGVAR(main,cleanup),_outpost getVariable [QGVAR(composition),[]]] call CBA_fnc_serverEvent;
    [QEGVAR(main,cleanup),_garrison getVariable [QGVAR(composition),[]]] call CBA_fnc_serverEvent;
    [QEGVAR(main,cleanup),_comms getVariable [QGVAR(composition),[]]] call CBA_fnc_serverEvent;

    // cleanup comm array units if still active
    if (_comms getVariable [QGVAR(active),1] isEqualTo 1) then {
        [QEGVAR(main,cleanup),_comms getVariable [QGVAR(groups),[]]] call CBA_fnc_serverEvent;
    };

    // remove tasks 
    [_outpost getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;
    [_garrison getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;
    [_comms getVariable [QGVAR(task),""],true] call BIS_fnc_deleteTask;

    // remove map polygons
    [
        [_value getVariable [QGVAR(polygonDraw),[]]],
        {
            {
                (findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", _x];
            } forEach (_this select 0); 
        }
    ] remoteExecCall [QUOTE(call), 0, false];
}] call CBA_fnc_hashEachPair;

nil