/*
Author: Nicholas Clark (SENSEI)

Description:
gets list of players
allPlayers command is faster, but it returns an empty array (on dedicated) until some time after time = 0
This function also excludes headless clients, unlike allPlayers

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_allPlayers"];

_allPlayers = [];
{
	if (isPlayer _x) then {
		_allPlayers pushBack _x;
	};
} forEach (playableUnits + allDeadMen);

_allPlayers