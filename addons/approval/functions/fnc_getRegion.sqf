/*
Author:
Nicholas Clark (SENSEI)

Description:
get locations in region, should not be called directly in most cases

Arguments:
0: center position <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_nearest"];
params [["_position",[]]];

_nearest = [];

if (_position isEqualTo []) exitWith {_nearest};

{
	if (CHECK_DIST2D(_x select 1,_position,EGVAR(main,range)*0.2 max 1000)) then {
		_nearest pushBack _x;
	};
	false
} count EGVAR(main,locations);

_nearest