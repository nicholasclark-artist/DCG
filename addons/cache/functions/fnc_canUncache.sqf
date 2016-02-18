/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if group should be uncached

Arguments:
0: group to be uncached <GROUP>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [["_grp",grpNull]];

_grp getVariable [CACHE_DISABLE_VAR,false] || {!(([leader _grp,GVAR(dist)] call EFUNC(main,getNearPlayers)) isEqualTo [])} || {!(isNull (leader _grp findNearestEnemy leader _grp))}