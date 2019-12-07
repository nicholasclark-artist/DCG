/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize garrison addon 

Arguments:
0: data loaded from server profile <ARRAY>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"
#define REINIT \
        [{call FUNC(init)},[],60] call CBA_fnc_waitAndExecute; \
        WARNING("init failed, retry after cooldown")

if !(isServer) exitWith {false};

params [
    ["_data",[],[[]]]
];

// find ao's
private _ao = call FUNC(setArea);

// retry if failed to find ao
if !(_ao) exitWith {
    // call FUNC(removeArea);
    // REINIT;
};

// find suitable spawn areas
call FUNC(setOutpost);
// call FUNC(setGarrison);
// call FUNC(setComms);

// retry if score too low
if (GVAR(score) <= 0) exitWith {
    // call FUNC(removeArea);
    // REINIT;
};

// spawn in rolling fashion
call FUNC(spawnOutpost);

[{
    call FUNC(spawnGarrison);
}, [], 5] call CBA_fnc_waitAndExecute;

[{
    call FUNC(spawnComm);
}, [], 10] call CBA_fnc_waitAndExecute;

// @todo compare scores and spawn dynamic task in low score area to give each AO a point of interest

// @todo lower approval in regions occupied by enemy 

// draw ao on map 
private _polygons = [];
private _id = "";

[GVAR(areas),{
    _polygons pushBack (_value getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON]);
    _id = _value getVariable [QGVAR(polygonDraw),""];
}] call CBA_fnc_hashEachPair;

[
    [_polygons,_id],
    {
        {
            [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",true,findDisplay 12 displayCtrl 51,_this select 1] call EFUNC(main,polygonFill);
        } forEach (_this select 0); 
    }
] remoteExecCall [QUOTE(call), 0, false];

// set tasks 
call FUNC(setTask);

// run handler
// [FUNC(handleArea), 30] call CBA_fnc_addPerFrameHandler;

nil