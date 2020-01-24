/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize garrison addon 

Arguments:
0: data loaded from server profile <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define REINIT \
        call FUNC(removeArea); \
        [FUNC(init),[],10] call CBA_fnc_waitAndExecute; \
        WARNING("init failed, retry after cooldown")

if !(isServer) exitWith {nil};

params [
    ["_data",[],[[]]]
];

// find initial areas
private _ao = [AO_COUNT_P1] call FUNC(setArea);

// retry on fail
if !(_ao) exitWith {
    REINIT;
};

// find suitable spawn areas
private _outpost = [OP_COUNT] call FUNC(setOutpost);

// retry on fail
if !(_outpost) exitWith {
    REINIT;
};

// @todo improve fps drop
[] spawn FUNC(spawnArea); 
// call FUNC(spawnOutpost);

// draw ao on map 
private _polygons = [];

[GVAR(areas),{
    _polygons pushBack (_value getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON]);
}] call CBA_fnc_hashEachPair;

[
    [_polygons],
    {
        {
            [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",true,findDisplay 12 displayCtrl 51,QGVAR(polygonDraw)] call EFUNC(main,polygonFill);
        } forEach (_this select 0); 
    }
] remoteExecCall [QUOTE(call),0,false];

// set tasks 
call FUNC(setTask);

// run handler
// [FUNC(handleArea),30] call CBA_fnc_addPerFrameHandler;

nil