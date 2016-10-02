/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		GVAR(blacklist) pushBack [locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)]; // add main base to blacklist
		if (!isNil {HEADLESSCLIENT} && {!(CHECK_ADDON_1("acex_headless"))}) then { // let ace handle transfer if enabled
			(owner HEADLESSCLIENT) publicVariableClient QFUNC(handlePatrol);
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);

			remoteExecCall [QFUNC(handlePatrol), owner HEADLESSCLIENT, false];
		} else {
			call FUNC(handlePatrol);
		};

		ADDON = true;
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;