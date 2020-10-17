/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn units, should not be called directly and must run in scheduled environment, caching is deferred on garrison groups

Arguments:

Return:
string
__________________________________________________________________*/
#include "script_component.hpp"
#define SPAWN_DELAY 1
#define INF_GRPCOUNT 4 // number of units in group
#define VEH_CARGOCOUNT 4 // number of units to cargo

params [
    ["_location",locationNull,[locationNull]],
    ["_side",EGVAR(main,enemySide),[sideUnknown]],
    ["_garrisonCount",0,[0]],
    ["_patrolCount",0,[0]],
    ["_vehicleCount",0,[0]]
];

private ["_garrisonGroups","_patrolGroups","_vehicleGroups","_position","_posSpawn","_grp"];

_garrisonGroups = [];
_patrolGroups = [];
_vehicleGroups = [];

_position =+ (_location getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS]);
_position set [2,0];

/*
    garrison groups
*/
if (_garrisonCount >= 1) then {
    _posSpawn = [_position,50,100,2,0,-1,[0,360],_position getPos [50,random 360]] call EFUNC(main,findPosSafe);

    for "_i" from 1 to floor (_garrisonCount / INF_GRPCOUNT) max 1 do {
        _grp = [_posSpawn,0,INF_GRPCOUNT,_side,SPAWN_DELAY,0,true] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;
        _garrisonGroups pushBack _grp;

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * INF_GRPCOUNT);
    };
};

/*
    patrol groups
*/
if (_patrolCount >= 1) then {
    _posSpawn = [_position,100,150,2,0,-1,[0,360],_position getPos [100,random 360]] call EFUNC(main,findPosSafe);

    for "_i" from 1 to floor (_patrolCount / INF_GRPCOUNT) max 1 do {
        _grp = [_posSpawn,0,INF_GRPCOUNT,_side,SPAWN_DELAY] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;
        _patrolGroups pushBack _grp;

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * INF_GRPCOUNT);
    };
};
/*
    vehicle patrol groups
*/
if (_vehicleCount >= 1) then {
    _posSpawn = [_position,100,150,10,0,0.3,[0,360],_position getPos [100,random 360]] call EFUNC(main,findPosSafe);

    for "_i" from 1 to floor _vehicleCount do {
        _grp = [_posSpawn,(round random 1) + 1,-1,_side,SPAWN_DELAY,VEH_CARGOCOUNT] call EFUNC(main,spawnGroup);

        [QGVAR(updateGroups),[_location,_grp]] call CBA_fnc_localEvent;
        _vehicleGroups pushBack _grp;

        // infinite fuel
        (objectParent leader _grp) addEventHandler ["Fuel",{
            if !(_this select 1) then {(_this select 0) setFuel 1};
        }];

        // wait until entire group is spawned before moving to next group
        sleep (SPAWN_DELAY * VEH_CARGOCOUNT);
    };
};

[_garrisonGroups,_patrolGroups,_vehicleGroups]