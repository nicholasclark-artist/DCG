/*
Author:
Nicholas Clark (SENSEI)

Description:
handles civilian vehicle spawns

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define BUFFER 50
#define ROAD_SEARCH_DIST 250
#define ROUTE_DIST 3000

GVAR(drivers) =  GVAR(drivers) select {!isNull _x};

if (count GVAR(drivers) <= ceil GVAR(vehLimit)) then {
    private _player = selectRandom ((call CBA_fnc_players) select {((getPos _x) select 2) < 10});

    if (isNil "_player" || {[_player] call EFUNC(main,inSafezones)}) exitWith {};

    private _roads = _player nearRoads ROAD_SEARCH_DIST;

    // get start and end point for vehicle that passes by target player
    if !(_roads isEqualTo []) then {
        private _roadMid = selectRandom _roads;

        if (isNil "_roadMid") exitWith {};

        private _direction = random 360;

        private _roadStart = selectRandom ((_player getPos [ROUTE_DIST*0.5,_direction]) nearRoads ROAD_SEARCH_DIST);

        if (isNil "_roadStart") exitWith {};

        private _roadEnd = selectRandom ((_player getPos [ROUTE_DIST*0.5,(_direction + 180) mod 360]) nearRoads ROAD_SEARCH_DIST);

        if (isNil "_roadEnd") exitWith {};

        private ["_roadTemp","_posRoadStart","_posRoadEnd"];

        if (PROBABILITY(0.5)) then {
            _roadTemp = _roadStart;
            _roadStart = _roadEnd;
            _roadEnd = _roadTemp;
        };
        
        _posRoadStart = getPosATL _roadStart;
        _posRoadEnd = getPosATL _roadEnd;

        if (([_posRoadStart,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo [] &&
            {([_posRoadEnd,BUFFER] call EFUNC(main,getNearPlayers)) isEqualTo []} &&
            {!([_roadStart,_roadEnd] call EFUNC(main,inSafezones))}) then {
                [_roadStart,_roadMid,_roadEnd] call FUNC(spawnVehicle);
                // {
                //     deleteMarker _x
                // } forEach TEST_MARKERS;
                // TEST_MARKERS = [];
                // {
                //     _m = createMarker [[diag_frameNo,_forEachIndex] joinString "",getPosATL _x];
                //     _m setMarkerType "mil_dot";
                //     _m setMarkerText str _forEachIndex;
                //     TEST_MARKERS pushBack _m;
                // } forEach [_roadStart,_roadMid,_roadEnd];
        };
    };
}; 

nil