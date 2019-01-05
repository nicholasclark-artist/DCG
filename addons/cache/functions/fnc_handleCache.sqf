/*
Author:
Nicholas Clark (SENSEI)

Description:
handle additions to dynamic simulation system

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

{
    if (!(dynamicSimulationEnabled _x) && {!(isPlayer leader _x)} && {!(_x getVariable [CACHE_DISABLE,false])}) then {
        _x enableDynamicSimulation true;
        // LOG_1("Enable dynamic simulation: %1",_x);
    };
    false
} count allGroups;

false
