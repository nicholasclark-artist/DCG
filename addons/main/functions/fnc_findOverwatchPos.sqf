/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/22/2015

Description: find overwatch positions

Note: _pos must be positionASL

Return: array
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
_posArray = [_pos,35,_max,_min,1] call EFUNC(main,findPosGrid);

{
	if (count _ret isEqualTo _count) exitWith {};
	if (!(terrainIntersectASL [[_x select 0,_x select 1,(_x select 2) + 2],_pos]) && {(_x select 2) - (_pos select 2) >= _height}) then {
		_ret pushBack _x;
	};
} forEach _posArray;

_ret