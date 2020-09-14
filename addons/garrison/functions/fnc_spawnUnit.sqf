/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn units, should not be called directly and must run in scheduled environment

Arguments:
0: location <LOCATION>
1: area location <LOCATION>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY (1.5 max 0.1)

// @todo disallow water waypoints

params [
    ["_location",locationNull,[locationNull]],
    ["_ao",locationNull,[locationNull]]
];

// get variables
private _radius = _location getVariable [QGVAR(radius),0];
private _position =+ (_location getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]);
_position set [2,0];

private _count = 0;
private _type = "";

(_location getVariable [QGVAR(type),""]) call {
    if (COMPARE_STR(_this,"outpost")) exitWith {
        _count = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"comm")) exitWith {
        _count = [8,16,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"garrison")) then {
        (_ao getVariable [QEGVAR(main,type),""]) call {
            if (COMPARE_STR(_this,"namecitycapital")) exitWith {
                _count = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namecity")) exitWith {
                _count = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namevillage")) exitWith {
                _count = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
        };
    };
};

// PATROLS

// get patrol spawn position in safe area around composition
private _posPatrol = [_position,_radius + 10,_radius + 50,2,0,-1,[0,360],_position getPos [_radius + 20,random 360]] call EFUNC(main,findPosSafe);

// // spawn infantry patrols, patrols will navigate outpost exterior and investigate nearby buildings
private _countPatrol = ceil (_count * 0.65);

private ["_grp"];

for "_i" from 1 to floor (1 max (_countPatrol / PAT_GRPSIZE)) do {
    _grp = [_posPatrol,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location"];

            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            [_grp,getPos _location,random [100,200,300],1,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
        },
        [_grp,_location],
        (SPAWN_DELAY * _countPatrol) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

// BUILDING INFANTRY

// spawn building infantry, units will garrison buildings
private _countBuildings = floor (_count * 0.35);

for "_i" from 1 to floor (1 max (_countBuildings / PAT_GRPSIZE)) do {
    _grp = [_position,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location","_radius"];

            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            [_grp,getPos _location,_radius,0] call EFUNC(main,taskDefend);
        },
        [_grp,_location,_radius],
        (SPAWN_DELAY * _countBuildings) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

nil