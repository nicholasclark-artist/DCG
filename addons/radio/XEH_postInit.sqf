/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

CHECK_ADDON;

[[],{
	INFO("Init radio settings");

	call FUNC(handleLoadout);
	call FUNC(setRadioSettings);
}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];

ADDON = true;
