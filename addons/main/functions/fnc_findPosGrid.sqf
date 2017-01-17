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
4: min distance from object <NUMBER>
5: allow water <BOOL>
6: shuffle position array <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#ifdef DEBUG_MODE_FULL
  #define GRID_DEBUG true
#else
  #define GRID_DEBUG false
#endif

params [
	["_anchor",[0,0,0],[[]]],
	["_dist",64,[0]],
	["_range",256,[0]],
	["_rangeMin",0,[0]],
	["_distObj",0,[0]],
	["_water",-1,[0]],
	["_shuffle",false,[false]]
];

private _ret = [];
private _origin = [(_anchor select 0) - (_range/2),(_anchor select 1) - (_range/2)];
private _count = floor (_range/_dist);

for "_y" from 0 to _count do {
    private _column = [_origin select 0,(_origin select 1) + (_dist*_y)];
	_ret pushBack _column;

    for "_x" from 1 to _count do {
        private _row = [(_column select 0) + (_dist*_x), _column select 1];
        _ret pushBack _row;
    };
};

_ret = _ret select {
    !(_x inArea [_anchor, _rangeMin, _rangeMin, 0, false, -1]) &&
    {[_x,_distObj,_water] call FUNC(isPosSafe)}
};

{
    _x set [2,(getTerrainHeightASL _x) max 0]
} forEach _ret;

if (_shuffle) then {
	[_ret,(count _ret)*3] call FUNC(shuffle);
};

if (GRID_DEBUG) then {
    {
        _mrk = createMarker [format ["debug_%1", _x], _x];
        _mrk setMarkerType "mil_dot";
        _mrk setMarkerColor "ColorGrey";
        _mrk setMarkerText str (_x select 2);
    } forEach _ret;
};

_ret
