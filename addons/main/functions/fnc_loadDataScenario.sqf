/*
Author:
Nicholas Clark (SENSEI)

Description:
check server profile for saved data and assign it for current scenario

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer && {!is3DEN}) exitWith {};

{
    if (toUpper (_x select 0) isEqualTo SAVE_SCENARIO_ID) exitWith {
        GVAR(saveDataScenario) = _x;
    };
} forEach (SAVE_GETVAR);

nil