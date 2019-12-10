/*
Author:
Nicholas Clark (SENSEI)

Description:
calculate convex polygon centroid,not necessarily the same as the visual center

Arguments:
0: polygon vertices <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[[0,0,0],[0,0,0],[0,0,0]],[[]]]
];

private _c = [0,0,0];

{
    _c = _c vectorAdd _x;
} forEach _polygon;

[(_c select 0) / (count _polygon),(_c select 1) / (count _polygon),0]