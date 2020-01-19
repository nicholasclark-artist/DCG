/*
Author:
Nicholas Clark (SENSEI)

Description:
get longest side of polygon's bounding box
https://www.mathopenref.com/coordbounds.html

Arguments:
0: polygon vertices <ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",DEFAULT_POLYGON,[[]]]
];

private _xCoords = _polygon apply {_x select 0};
private _yCoords = _polygon apply {_x select 1};

((selectMax _xCoords) - (selectMin _xCoords)) max ((selectMax _yCoords) - (selectMin _yCoords))