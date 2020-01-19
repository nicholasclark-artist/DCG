/*
Author:
Nicholas Clark (SENSEI)

Description:
calculate convex polygon centroid or visual center
https://www.mathopenref.com/coordcentroid.html

Arguments:
0: polygon vertices <ARRAY>
1: type, centroid or visual center <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",DEFAULT_POLYGON,[[]]],
    ["_type",0,[0]]
];

// calculate centroid
if (_type isEqualTo 0) exitWith {
    private _c = [0,0,0];

    {
        _c = _c vectorAdd _x;
    } forEach _polygon;

    [(_c select 0) / (count _polygon),(_c select 1) / (count _polygon),0]
};

// calculate visual center
private _xCoords = _polygon apply {_x select 0};
private _yCoords = _polygon apply {_x select 1};

([selectMin _xCoords,selectMin _yCoords,0] vectorAdd [selectMax _xCoords,selectMax _yCoords,0]) vectorMultiply 0.5;