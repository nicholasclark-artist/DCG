/*
Author:
Nicholas Clark (SENSEI)

Description:
find grid of positions (position2D)

Arguments:
0: center position <ARRAY>
1: distance between positions <NUMBER>
2: length of grid <NUMBER>
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
    ["_length",256,[0]],
    ["_distMin",0,[0]],
    ["_distObj",0,[0]],
    ["_water",-1,[0]],
    ["_shuffle",false,[false]]
];

private _ret = [];

// get origin in bottom left corner
private _pO = [(_center select 0) - (_length*0.5),(_center select 1) - (_length*0.5)];

// number of points to generate length-wise
private _count = floor (_length/_spacing);

private ["_pY","_pX","_mrk"];

// generate columns
for "_i" from 0 to _count do {
    _pY = [_pO select 0,(_pO select 1) + (_spacing * _i)];
    _ret pushBack _pY;

    // generate rows
    for "_i" from 1 to _count do {
        _pX = [(_pY select 0) + (_spacing * _i),_pY select 1];
        _ret pushBack _pX;
    };
};

if (_distMin > 0) then {
    _ret = _ret select {!(_x inArea [_center,_distMin,_distMin,0,false,-1])};
};

if (_distObj > 0 || {_water > -1}) then {
    _ret = _ret select {[_x,_distObj,_water] call FUNC(isPosSafe)};
};

// {
//     _mrk = createMarker [format["%1_grid_%2",QUOTE(PREFIX),diag_frameNo + _forEachIndex],_x];
//     _mrk setMarkerType "mil_dot";
//     _mrk setMarkerColor "ColorUNKNOWN";
//     _mrk setMarkerText format["%1",_forEachIndex];
// } forEach _ret;

if (_shuffle) then {
    _ret = _ret call BIS_fnc_arrayShuffle;
};

_ret