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
#define CIV_RANGE 999

// @todo remove mid waypoint if 'forceFollowRoad' is usable
private ["_player","_roads","_roadStart","_roadEnd","_roadMid","_road","_roadConnect"];

if (count GVAR(drivers) <= ceil GVAR(vehLimit)) then {
    _player = selectRandom ((call CBA_fnc_players) select {((getPos _x) select 2) < 10});

    if (isNil "_player" || {[_player] call EFUNC(main,inSafezones)}) exitWith {};

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
            if (_i isEqualTo CIV_ITERATIONS || {!(CHECK_DIST2D(getPosATL _road,getPosATL _roadMid,CIV_RANGE))}) exitWith {
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
            if (_i isEqualTo CIV_ITERATIONS || {!(CHECK_DIST2D(getPosATL _road,getPosATL _roadMid,CIV_RANGE))}) exitWith {
                _roadEnd = _road;
            };
        };

        private ["_posRoadStart","_posRoadMid","_posRoadEnd","_eyePosRoadStart"];

        // chance to swap start/end position
        if (PROBABILITY(0.5)) then {
            _posRoadStart = getPosATL _roadStart;
            _posRoadEnd = getPosATL _roadEnd;
        } else {
            _posRoadStart = getPosATL _roadEnd;
            _posRoadEnd = getPosATL _roadStart;
        };

        _posRoadMid = getPosATL _roadMid;
        _eyePosRoadStart = ATLtoASL _posRoadStart;
        _eyePosRoadStart = _eyePosRoadStart vectorAdd [0,0,1.5];

        if (!(CHECK_DIST2D(_posRoadStart,_posRoadEnd,CIV_RANGE)) &&
            {!([_eyePosRoadStart,eyePos _player] call EFUNC(main,inLOS))} &&
            {([_posRoadStart,CIV_BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
            {([_posRoadEnd,CIV_BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
            {!([_roadStart,_roadEnd] call EFUNC(main,inSafezones))}) then {
                [_roadStart,_roadMid,_roadEnd] call FUNC(spawnVehicle);
        };
    };
}; 
