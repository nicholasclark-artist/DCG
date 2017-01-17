/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if group can be cached

Arguments:
0: group to be cached <GROUP>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [["_grp",grpNull]];

!isNull _grp && {count units _grp > 1} && {!(_grp in GVAR(groups))} && {!(_grp getVariable [CACHE_DISABLE_VAR,false])} && {([getPos leader _grp,GVAR(dist)] call EFUNC(main,getNearPlayers)) isEqualTo []} && {isNull (leader _grp findNearestEnemy leader _grp)}
