/*
Author:
Nicholas Clark (SENSEI)

Description:
sort polygon vertices in clockwise order

Arguments:
0: polygon vertices <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[],[[]]]
];

// order polygon vertices 
private _center = [0,0,0];
private _dirToArr = [];
private _polygonIndices = [];
private _polygonSorted = [];

// get center of polygon
{
    _center = _center vectorAdd _x;
} forEach _polygon;

_center = [(_center select 0) / ((count _polygon) max 1),(_center select 1) / ((count _polygon) max 1),0];

// sort by vert direction from center
{
    _dirToArr pushBack [_center getDir _x,_forEachIndex];
} forEach _polygon;

_dirToArr sort true;

// sort value based on direction order
_polygonIndices = _dirToArr apply {_x select 1};
_polygonSorted resize (count _polygon);

for "_i" from 0 to (count _polygon) - 1 do {
    _polygonSorted set [_i,_polygon select (_polygonIndices select _i)];
};

_polygonSorted