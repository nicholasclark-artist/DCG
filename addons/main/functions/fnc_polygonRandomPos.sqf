/*
Author:
Nicholas Clark (SENSEI)

Description:
find random positions in convex polygon

Arguments:
0: polygon vertices <ARRAY>
1: number of positions to find <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",DEFAULT_POLYGON,[[]]],
    ["_count",1,[0]]
];

private _ret = [];

// split polygon into triangles
private _triangles = [_polygon] call FUNC(polygonTriangulate);

// select random triangle weighted by area
private _weights = [];

{
    _weights pushBack ([_x] call FUNC(polygonArea));
} forEach _triangles;

private ["_tri","_r1","_r2","_p"];

for "_i" from 0 to _count - 1 do {
    _tri = _triangles selectRandomWeighted _weights;

    // generate random point in triangle
    _r1 = random 1;
    _r2 = random 1;

    _p = ((_tri select 0) vectorMultiply (1 - sqrt(_r1))) vectorAdd ((_tri select 1) vectorMultiply (sqrt(_r1) * (1 - _r2))) vectorAdd ((_tri select 2) vectorMultiply (sqrt(_r1) * _r2));

    _ret pushBack _p;  
};

_ret