/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[[],{
	INFO("Init radio settings");

	call FUNC(handleLoadout);
	call FUNC(setRadioSettings);
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];

ADDON = true;
