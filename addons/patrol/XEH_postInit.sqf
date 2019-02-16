/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

// {
//     GVAR(blacklist) pushBack [getpos _x, (triggerArea _x) select 0];
// } forEach EGVAR(main,safezoneTriggers);

[FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
