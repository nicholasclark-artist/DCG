/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

[FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
