/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn units, should not be called directly

Arguments:
0: location <LOCATION>
1: area location <LOCATION>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY 0.5

// @todo disallow water waypoints

params [
    ["_location",locationNull,[locationNull]],
    ["_ao",locationNull,[locationNull]]
];

// get variables 
private _radius = _location getVariable [QGVAR(radius),0];
private _position =+ (_location getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]); 
_position set [2,0];

private _unitCount = 0;
private _type = "";

(_location getVariable [QGVAR(type),""]) call {
    if (COMPARE_STR(_this,"outpost")) exitWith {
        _unitCount = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"comm")) exitWith {
        _unitCount = [8,16,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"garrison")) then {
        (_ao getVariable [QEGVAR(main,type),""]) call {
            if (COMPARE_STR(_this,"namecitycapital")) exitWith {
                _unitCount = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namecity")) exitWith {
                _unitCount = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namevillage")) exitWith {
                _unitCount = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
        };
    };
};

// PATROLS

// get patrol spawn position in safe area around composition
private _posPatrol = [_position,_radius + 10,_radius + 50,2,0,-1,[0,360],_position getPos [_radius + 20,random 360]] call EFUNC(main,findPosSafe);

// spawn infantry patrol, patrols will navigate outpost exterior and investigate nearby buildings
for "_i" from 1 to floor (1 max (_unitCount / PAT_GRPSIZE)) do {
    private _grp = [_posPatrol,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location"];

            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            // set group on patrol
            [_grp,getPosATL _location,random [100,200,500],1,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
        },
        [_grp,_location],
        ((SPAWN_DELAY max 0.1) * (_unitCount max 1)) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

// BUILDING INFANTRY

private _buildings = _position nearObjects ["House",_radius];
_buildings = _buildings select {!((_x buildingPos -1) isEqualTo [])};

_unitCount = ceil (count _buildings * 0.4);

for "_i" from 1 to floor (1 max (_unitCount / PAT_GRPSIZE)) do {
    private _grp = [_position,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location","_radius"];
            
            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            // set group to defend composition
            [_grp,getPosATL _location,_radius] call EFUNC(main,taskDefend);
        },
        [_grp,_location,_radius],
        ((SPAWN_DELAY max 0.1) * (_unitCount max 1)) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

nil