/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

{

	false
} count EGVAR(main,locations);
ADDON = true;