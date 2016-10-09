/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[
	{DOUBLES(PREFIX,main)},
	{
		call FUNC(handleVehicle);
		call FUNC(handleUnit);
		call FUNC(handleAnimal);
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;