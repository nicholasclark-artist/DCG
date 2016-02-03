/*
Author:
Nicholas Clark (SENSEI)

Description:
find overwatch positions, position argument must be positionASL

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

private ["_ret","_posArray"];
params [
	"_pos",
	["_count",4,[0]],
	["_min",500,[0]],
	["_max",1000,[0]],
	["_height",50,[0]]
];

_ret = [];
_posArray = [_pos,75,_max,_min,1] call EFUNC(main,findPosGrid);

{
	if (count _ret isEqualTo _count) exitWith {};
	if (!(terrainIntersectASL [[_x select 0,_x select 1,(_x select 2) + 2],_pos]) && {(_x select 2) - (_pos select 2) >= _height}) then {
		_ret pushBack _x;
	};
} forEach _posArray;

_ret