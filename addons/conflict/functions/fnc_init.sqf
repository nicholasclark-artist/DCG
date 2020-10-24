/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize addon

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {nil};

// find initial areas
private _ao = [AO_COUNT] call FUNC(setArea);

if !(_ao) exitWith {
    [QGVAR(reinit),nil] call CBA_fnc_serverEvent;
};

// find suitable spawn areas
private _outpost = [OP_COUNT] call FUNC(setOutpost);

if !(_outpost) exitWith {
    [QGVAR(reinit),nil] call CBA_fnc_serverEvent;
};

// find dynamic task
/*

*/

private _comm = call FUNC(setComm);

[] spawn FUNC(spawnArea);
[] spawn FUNC(spawnOutpost);
[] spawn FUNC(spawnComm);

// run handlers
// call FUNC(handleComm);

// draw ao on map
[GVAR(areas),{
    [
        [_key,[_value getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON]]],
        {
            {
                [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",true,findDisplay 12 displayCtrl 51,AO_POLY_ID(_this select 0)] call EFUNC(main,polygonFill);
            } forEach (_this select 1);
        }
    ] remoteExecCall [QUOTE(call),0,false];
}] call CBA_fnc_hashEachPair;

// set tasks
call FUNC(setTask);

nil