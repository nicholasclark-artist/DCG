/*
Author:
Nicholas Clark (SENSEI)

Description:
find grid of positions (positionASL)

Arguments:
0: center position <ARRAY>
1: distance between positions <NUMBER>
2: max distance from center <NUMBER>
3: min distance from center <NUMBER>
4: min distance from objects <NUMBER>
5: over land or water <NUMBER>
6: shuffle position array <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_anchor",
	["_dist",64,[0]],
	["_range",256,[0]],
	["_rangeMin",0,[0]],
	["_distObj",0,[0]],
	["_water",-1,[0]],
	["_shuffle",false,[false]]
];

private _ret = [];
private _origin = [(_anchor select 0) - (_range*0.5),(_anchor select 1) - (_range*0.5)];
private _count = floor (_range/_dist);

private ["_column", "_row"];

for "_y" from 0 to _count do {
    _column = [_origin select 0,(_origin select 1) + (_dist*_y)];
	_ret pushBack _column;

    for "_x" from 1 to _count do {
        _row = [(_column select 0) + (_dist*_x), _column select 1];
        _ret pushBack _row;
    };
};

_ret = _ret select {!(_x inArea [_anchor, _rangeMin, _rangeMin, 0, false, -1])};

if (_distObj > 0 || {_water > -1}) then {
    _ret = _ret select {[_x,_distObj,_water] call FUNC(isPosSafe)};
};

{
    _x set [2,(getTerrainHeightASL _x) max 0];

    _mrk = createMarker [format["posGrid_%1",diag_frameNo + _forEachIndex], _x];
    _mrk setMarkerType "mil_dot";
    _mrk setMarkerColor "ColorUNKNOWN";
    _mrk setMarkerText format["%1 (%2)",_forEachIndex, _x select 2];
    [_mrk] call FUNC(setDebugMarker);
} forEach _ret;

if (_shuffle) then {
	[_ret] call FUNC(shuffle);
}; 

_ret