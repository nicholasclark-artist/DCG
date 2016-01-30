/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main) && {time > 5}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		GVAR(blacklist) pushBack [locationPosition EGVAR(main,mobLocation),EGVAR(main,mobRadius)]; // add main base to blacklist
		if !(isNil {HEADLESSCLIENT}) then {
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);
			remoteExecCall [QFUNC(PFH), owner HEADLESSCLIENT, false];
		} else {
			call FUNC(PFH);
		};

		ADDON = true;
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;