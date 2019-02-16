/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian vehicle spawns

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CIV_ITERATIONS 300
#define CIV_BUFFER 100
#define CIV_RANGE 1000

// @todo remove mid waypoint if 'forceFollowRoad' is usable
private ["_player","_roads","_roadStart","_roadEnd","_roadMid","_road","_roadConnect"];

if (count GVAR(drivers) <= ceil GVAR(vehLimit)) then {
    _player = selectRandom ((call CBA_fnc_players) select {((getPos _x) select 2) < 10});

    if (isNil "_player") exitWith {};

    if (!GVAR(allowSafezone) && {[_player] call EFUNC(main,inSafezones)}) exitWith {};
    
    _roads = _player nearRoads 200;

    // get start and end point for vehicle that passes by target player
    if !(_roads isEqualTo []) then {
        _roadStart = objNull;
        _roadEnd = objNull;

        // get midpoint road
        _roadMid = _roads select 0;
        _road = _roadMid;

        // get roads in start direction
        for "_i" from 1 to CIV_ITERATIONS do {
            _roadConnect = roadsConnectedTo _road;

            // if next road doesn't exist, exit with last road
            if (isNil {_roadConnect select 0}) exitWith {
                _roadStart = _road;
            };

            _road = _roadConnect select 0;

            // if loop is done or road is far enough
            if (!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,CIV_RANGE)) || {_i isEqualTo CIV_ITERATIONS}) exitWith {
                _roadStart = _road;
            };
        };

        _road = _roadMid;

        // get roads in end direction
        for "_i" from 1 to CIV_ITERATIONS do {
            _roadConnect = roadsConnectedTo _road;

            // if next road doesn't exist, exit with last road
            // also check if array is empty, 'select' will throw error when checking for an element more than one index out of range
            if (_roadConnect isEqualTo [] || {isNil {_roadConnect select 1}}) exitWith {
                _roadEnd = _road;
            };

            _road = _roadConnect select 1;

            // if loop is done or road is far enough
            if (!(CHECK_VECTORDIST(getPosASL _road,getPosASL _roadMid,CIV_RANGE)) || {_i isEqualTo CIV_ITERATIONS}) exitWith {
                _roadEnd = _road;
            };
        };

        if (!(_roadStart isEqualTo _roadEnd) &&
            {!(CHECK_VECTORDIST(getPosASL _roadStart,getPosASL _roadEnd,CIV_RANGE))} &&
            {!([[(getPosASL _roadStart) select 0,(getPosASL _roadStart) select 1,(getTerrainHeightASL (getPos _roadStart)) + 1.5],eyePos _player] call EFUNC(main,inLOS))} &&
            {([getPos _roadStart,CIV_BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
            {([getPos _roadEnd,CIV_BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
            {!([_roadStart,_roadEnd] call EFUNC(main,inSafezones))}) then {
                [getPos _roadStart,getPos _roadMid,getPos _roadEnd,_player] call FUNC(spawnVehicle);
        };
    };
}; 
