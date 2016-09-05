/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

QUOTE(DOUBLES(ADDON,getLocations)) addPublicVariableEventHandler {
	_requestor = _this select 1;
	if (CHECK_ADDON_2(occupy)) then {
		(owner _requestor) publicVariableClient QEGVAR(occupy,occupiedLocations);
	};
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		[QUOTE(ADDON),"Transport","",QUOTE(call FUNC(canCallTransport)),QUOTE(call FUNC(getChildren))] remoteExecCall [QEFUNC(main,setAction), 0, true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;