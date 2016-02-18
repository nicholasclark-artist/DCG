/*
Author:
Nicholas Clark (SENSEI)

Description:
gets array of groups that are ready to be cached

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_ret"];

_ret = [];
{
	if (!isNull _x && {count units _x > 1} && {!(_x getVariable [CACHE_DISABLE_VAR,false])} && {!(_x in GVAR(groups))} && {!(isPlayer leader _x)} && {[leader _x,GVAR(dist)] call EFUNC(main,getNearPlayers) isEqualTo []}) then {
		_ret pushBack _x;
	};
} forEach allGroups;

_ret