/*
Author:
Nicholas Clark (SENSEI)

Description:
gets near players

Arguments:
0: center position <ARRAY>
1: distance from center to check <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_pos","_range","_players"];

_pos = _this select 0;
_range = _this select 1;
_players = [];

{
	if (CHECK_DIST2D(_x,_pos,_range)) then {
		_players pushBack _x;
	};
} forEach allPlayers;

_players