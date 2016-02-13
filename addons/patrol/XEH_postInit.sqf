/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		GVAR(blacklist) pushBack [locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)]; // add main base to blacklist
		if !(isNil {HEADLESSCLIENT}) then {
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);
			remoteExecCall [QFUNC(handler), owner HEADLESSCLIENT, false];
		} else {
			call FUNC(handler);
		};

		ADDON = true;
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;