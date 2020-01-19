/*
Author:
Nicholas Clark (SENSEI)

Description:
check if polygon is convex, polygon must be sorted
this function does not account for convex, self-intersecting polygons

Arguments:
0: polygon vertices <ARRAY>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(polygonIsConvex)

params [
    ["_polygon",DEFAULT_POLYGON,[[]]]
];

scopeName SCOPE;

private ["_p0","_p1","_p2","_z"];

private _p0 = _polygon select (count _polygon - 1);

for "_i" from 0 to (count _polygon  - 1) do {
    // get triplet of points / pair of edges (including p0)
    _p1 = _polygon select _i;
    _p2 = _polygon select (_i + 1);

    // get z component of cross product
    _z = ((_p1 vectorDiff _p0) vectorCrossProduct (_p2 vectorDiff _p1)) select 2;

    // convex polygon's z component will be positive / negative depending on sort order
    if (_z > 0) then {
        false breakOut SCOPE;
    };

    _p0 = _polygon select _i;
};

true