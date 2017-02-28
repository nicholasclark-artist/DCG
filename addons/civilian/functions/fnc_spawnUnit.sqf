/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn civilians

Arguments:
0: position to spawn civilians <ARRAY>
1: number of units to spawn <NUMBER>
2: name of location <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params ["_pos","_count","_name","_size"];

missionNamespace setVariable [LOCATION_ID(_name),true];

private _units = [];
private _buildings = _pos nearObjects ["House", _size min 200];

_buildings = _buildings select {
    !((_x buildingPos -1) isEqualTo [])
};

private _grp = [[0,0,0],0,_count,CIVILIAN,false,1.25] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_pos","_count","_size","_buildings"];

        {
            if !(_buildings isEqualTo []) then {
                _pos = selectRandom ((selectRandom _buildings) buildingPos -1);
            };

            _x setPos _pos;

            _id = [_x,_pos,_size] call FUNC(setPatrol);

            _x addEventHandler ["firedNear",format ["
                [%1] call CBA_fnc_removePerFrameHandler;
                (_this select 0) removeEventHandler [""firedNear"", _thisEventHandler];
                (_this select 0) setUnitPos ""DOWN"";
                doStop (_this select 0);
            ",_id]];
        } forEach units _grp;
	},
	[_grp,_pos,_count,_size,_buildings]
] call CBA_fnc_waitUntilAndExecute;

[{
    params ["_args","_idPFH"];
    _args params ["_pos","_name","_units"];

    if (([_pos,GVAR(spawnDist),ZDIST] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        _units call EFUNC(main,cleanup);
        missionNamespace setVariable [LOCATION_ID(_name),false];
    };
}, HANDLER_DELAY, [_pos,_name,units _grp]] call CBA_fnc_addPerFrameHandler;
