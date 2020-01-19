/*
Author:
Nicholas Clark (SENSEI)

Description:
split convex polygon into triangles, polygon must be sorted

Arguments:
0: polygon vertices <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",DEFAULT_POLYGON,[[]]]
];

private ["_ret","_vertices"];

_ret = [];

for "_i" from 0 to (count _polygon) - 3 do {
    _vertices = _polygon select [_i + 1,2];
    reverse _vertices;
    _vertices pushBack (_polygon select 0);
    reverse _vertices;
    _ret pushBack _vertices;
};

_ret