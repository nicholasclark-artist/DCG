/*
Author:
Nicholas Clark (SENSEI)

Description:
sort convex polygon vertices in clockwise order

Arguments:
0: polygon vertices <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[[0,0,0],[0,0,0],[0,0,0]],[[]]]
];

private _dirToArr = [];
private _polygonIndices = [];
private _polygonSorted = [];

// get centroid of polygon
private _centroid = [_polygon] call FUNC(polygonCentroid);

// sort by vertex direction from centroid
{
    _dirToArr pushBack [_centroid getDir _x,_forEachIndex];
} forEach _polygon;

// boolean determines sorting direction
_dirToArr sort true;

// sort vertex indices based on direction array order
_polygonIndices = _dirToArr apply {_x select 1};
_polygonSorted resize (count _polygon);

for "_i" from 0 to (count _polygon) - 1 do {
    _polygonSorted set [_i,_polygon select (_polygonIndices select _i)];
};

_polygonSorted