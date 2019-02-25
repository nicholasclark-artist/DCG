/*
Author:
Nicholas Clark (SENSEI)

Description:
find grid of positions (positionASL)

Arguments:
0: center position <ARRAY>
1: distance between positions <NUMBER>
2: diameter of grid <NUMBER>
3: minimum distance from center to find positions <NUMBER>
4: minimum distance from objects <NUMBER>
5: over land or water <NUMBER>
6: shuffle position array <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_center",[],[[]]],
    ["_spacing",64,[0]],
    ["_distMax",256,[0]],
    ["_distMin",0,[0]],
    ["_distObj",0,[0]],
    ["_water",-1,[0]],
    ["_shuffle",false,[false]]
];

private _ret = [];
private _origin = [(_center select 0) - (_distMax*0.5),(_center select 1) - (_distMax*0.5)];
private _count = floor (_distMax/_spacing);

private ["_column", "_row", "_mrk"];

for "_y" from 0 to _count do {
    _column = [_origin select 0,(_origin select 1) + (_spacing*_y)];
    _ret pushBack _column;

    for "_x" from 1 to _count do {
        _row = [(_column select 0) + (_spacing*_x), _column select 1];
        _ret pushBack _row;
    };
};

if (_distMin > 0) then {
    _ret = _ret select {!(_x inArea [_center, _distMin, _distMin, 0, false, -1])};
};

if (_distObj > 0 || {_water > -1}) then {
    _ret = _ret select {[_x,_distObj,_water] call FUNC(isPosSafe)};
};

{
    _x set [2,ASLZ(_x)];

    // _mrk = createMarker [format["%1_grid_%2",QUOTE(PREFIX),diag_frameNo + _forEachIndex], _x];
    // _mrk setMarkerType "mil_dot";
    // _mrk setMarkerColor "ColorUNKNOWN";
    // _mrk setMarkerText format["%1 (%2)",_forEachIndex, _x select 2];
    // [_mrk] call FUNC(setDebugMarker);
} forEach _ret;

if (_shuffle) then {
    [_ret] call FUNC(shuffle);
}; 

_ret