/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilians

Arguments:
0: position to spawn civilians <ARRAY>
1: number of units to spawn <NUMBER>
3: name of location <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_pos","_count","_name"];

private _units = [];
missionNamespace setVariable [LOCATION_ID(_name),true];

[{
    params ["_args","_idPFH"];
    _args params ["_pos","_count","_units"];

    if (count _units >= _count) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    _grp = createGroup CIVILIAN;
    (selectRandom EGVAR(main,unitPoolCiv)) createUnit [_pos, _grp];

    leader _grp addEventHandler ["firedNear",{
        [group (_this select 0)] call CBA_fnc_clearWaypoints;
        (_this select 0) removeEventHandler ["firedNear", _thisEventHandler];
        (_this select 0) forceSpeed ((_this select 0) getSpeed "FAST");
        (_this select 0) setUnitPos "MIDDLE";
        (_this select 0) doMove ([getposASL (_this select 0),50,100] call EFUNC(main,findPosSafe));
    }];

    [_grp, leader _grp, 100, 5, "MOVE", "CARELESS", "BLUE", "LIMITED", "STAG COLUMN", "", [8,10,20]] call CBA_fnc_taskPatrol;

    _units pushBack (leader _grp);
}, 1, [_pos,_count,_units]] call CBA_fnc_addPerFrameHandler;

[{
    params ["_args","_idPFH"];
    _args params ["_pos","_name","_units"];

    if ((allPlayers inAreaArray [_pos,GVAR(spawnDist),GVAR(spawnDist),0,false,ZDIST]) isEqualTo []) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        _units call EFUNC(main,cleanup);
        missionNamespace setVariable [LOCATION_ID(_name),false];
    };
}, HANDLER_DELAY, [_pos,_name,_units]] call CBA_fnc_addPerFrameHandler;
