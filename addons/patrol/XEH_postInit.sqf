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
		GVAR(blacklist) pushBack [locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)]; // add main base to blacklist

		if (!isNil {HEADLESSCLIENT} && {!(CHECK_ADDON_1("acex_headless"))}) then { // let ace handle transfer if enabled
			(owner HEADLESSCLIENT) publicVariableClient QFUNC(handlePatrol);
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);

			[FUNC(handlePatrol), GVAR(cooldown), []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler), owner HEADLESSCLIENT, false];
		} else {
			[FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
		};
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;