/*
Author:
Nicholas Clark (SENSEI)

Description:
find overwatch positions

Arguments:
0: center position <ARRAY>
1: number of positions to find <ARRAY>
2: minimum distance from center <NUMBER>
3: maximum distance from center <NUMBER>
4: height difference from center <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_pos",
	["_count",4,[0]],
	["_min",300,[0]],
	["_max",1000,[0]],
	["_height",50,[0]]
];

_pos set [2, getTerrainHeightASL _pos];

private _ret = [];
private _posArray = [_pos,75,_max,_min,1] call EFUNC(main,findPosGrid);

{
	if (count _ret isEqualTo _count) exitWith {};

	_overwatch = _x;
	_overwatch = _overwatch vectorAdd [0,0,2];

	if (!(terrainIntersectASL [_overwatch,_pos]) && {(_x select 2) - (_pos select 2) >= _height}) then {
		_ret pushBack _x;
	};
} forEach _posArray;

_ret