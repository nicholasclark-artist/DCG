/*
Author:
Nicholas Clark (SENSEI)

Description:
find random positionASL in convex polygon

Arguments:
0: polygon vertices <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[[0,0,0],[0,0,0],[0,0,0]],[[]]]
];

// split polygon into triangles
private _triangles = [_polygon] call FUNC(polygonTriangulate);

// select random triangle weighted by area
private _weights = [];

{
    _weights pushBack ([_x] call FUNC(polygonArea));
} forEach _triangles;

private _tri = _triangles selectRandomWeighted _weights;

// generate random point in triangle
private _r1 = random 1;
private _r2 = random 1;

private _ret = ((_tri select 0) vectorMultiply (1 - sqrt(_r1))) vectorAdd ((_tri select 1) vectorMultiply (sqrt(_r1) * (1 - _r2))) vectorAdd ((_tri select 2) vectorMultiply (sqrt(_r1) * _r2));

_ret set [2,ASLZ(_ret)];

_ret