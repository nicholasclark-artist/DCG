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

private _unitCountPatrol = 0;
private _type = "";

(_location getVariable [QGVAR(type),""]) call {
    if (COMPARE_STR(_this,"outpost")) exitWith {
        _unitCountPatrol = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"comm")) exitWith {
        _unitCountPatrol = [8,16,GVAR(countCoef)] call EFUNC(main,getUnitCount);
        _type = toLower _this;
    };
    if (COMPARE_STR(_this,"garrison")) then {
        (_ao getVariable [QEGVAR(main,type),""]) call {
            if (COMPARE_STR(_this,"namecitycapital")) exitWith {
                _unitCountPatrol = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namecity")) exitWith {
                _unitCountPatrol = [32,64,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
            if (COMPARE_STR(_this,"namevillage")) exitWith {
                _unitCountPatrol = [16,32,GVAR(countCoef)] call EFUNC(main,getUnitCount);
                _type = toLower _this;
            };
        };
    };
};

// PATROLS

// get patrol spawn position in safe area around composition
private _posPatrol = [_position,_radius + 10,_radius + 50,2,0,-1,[0,360],_position getPos [_radius + 20,random 360]] call EFUNC(main,findPosSafe);

// spawn infantry patrol, patrols will navigate outpost exterior and investigate nearby buildings
for "_i" from 1 to floor (1 max (_unitCountPatrol / PAT_GRPSIZE)) do {
    private _grp = [_posPatrol,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location"];
            
            // add eventhandlers
            {
                _x setVariable [QGVAR(location),_location];
                _x addEventHandler ["Killed",{
                    _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                    _location call (_location getVariable [QGVAR(onKilled),{}]);
                }]; 
            } forEach (units _grp);

            // [QGVAR(updateUnitCount),[_location,count units _grp]] call CBA_fnc_localEvent;
            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            // set group on patrol
            [_grp,getPosATL _location,random [100,200,500],1,"if (0.15 > random 1) then {this spawn CBA_fnc_searchNearby}"] call EFUNC(main,taskPatrol);
        },
        [_grp,_location],
        ((SPAWN_DELAY max 0.1) * (PAT_GRPSIZE * (_unitCountPatrol max 1))) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

// BUILDING INFANTRY

for "_i" from 1 to floor (1 max (count _buildings / PAT_GRPSIZE)) do {
    private _grp = [_position,0,PAT_GRPSIZE,EGVAR(main,enemySide),SPAWN_DELAY] call EFUNC(main,spawnGroup);

    [
        {(_this select 0) getVariable [QEGVAR(main,ready),false]},
        {
            params ["_grp","_location","_radius"];
            
            {
                // add eventhandlers
                _x setVariable [QGVAR(location),_location];
                _x addEventHandler ["Killed",{
                    _location = (_this select 0) getVariable [QGVAR(location),locationNull];
                    _location call (_location getVariable [QGVAR(onKilled),{}]);
                }]; 
            } forEach (units _grp);

            // [QGVAR(updateUnitCount),[_location,count units _grp]] call CBA_fnc_localEvent;
            [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;

            // set group to defend composition
            [_grp,getPosATL _location,_radius] call EFUNC(main,taskDefend);
        },
        [_grp,_location,_radius,_buildings],
        ((SPAWN_DELAY max 0.1) * (PAT_GRPSIZE * (count _buildings max 1))) * 2
    ] call CBA_fnc_waitUntilAndExecute;
};

nil