/*
Author:
Nicholas Clark (SENSEI)

Description:
check if two polygons intersect

Arguments:
0: polygon 1 <ARRAY>
1: polygon 2 <ARRAY>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_p1",DEFAULT_POLYGON,[[]]],
    ["_p2",DEFAULT_POLYGON,[[]]]
];

(_p1 findIf {_x inPolygon _p2}) >= 0 || (_p2 findIf {_x inPolygon _p1}) >= 0