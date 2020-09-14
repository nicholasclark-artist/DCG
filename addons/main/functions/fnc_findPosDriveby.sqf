/*
Author:
Nicholas Clark (SENSEI)

Description:
find road positions (positionATL) that create a route near passed position

Arguments:
0: center position <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define ROAD_SEARCH_DIST 500

params [
    ["_pos",[],[[]]],
    ["_dist",1000,[0]]
];

private _roads = _pos nearRoads ROAD_SEARCH_DIST;

if (_roads isEqualTo []) exitWith {[]};

private _rMid = selectRandom _roads;
private _dir = random 360;
private _rStart = selectRandom ((_pos getPos [_dist*0.5,_dir]) nearRoads ROAD_SEARCH_DIST);

if (isNil "_rStart") exitWith {[]};

private _rEnd = selectRandom ((_pos getPos [_dist*0.5,(_dir + 180) mod 360]) nearRoads ROAD_SEARCH_DIST);

if (isNil "_rEnd") exitWith {[]};

_ret = [getPosATL _rStart,getPosATL _rMid,getPosATL _rEnd];

if (PROBABILITY(0.5)) then {
    reverse _ret;
};

_ret