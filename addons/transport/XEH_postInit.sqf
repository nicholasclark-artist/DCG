/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

QUOTE(TRIPLES(PREFIX,transport,getLocations)) addPublicVariableEventHandler {
	_requestor = _this select 1;
	if (CHECK_ADDON_2(occupy)) then {
		(owner _requestor) publicVariableClient QEGVAR(occupy,occupiedLocations);
	};
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		{
			[QUOTE(ADDON),"Transport","",QUOTE(call FUNC(canCallTransport)),QUOTE(call FUNC(getChildren)),player,1] call EFUNC(main,setAction);
		} remoteExecCall ["BIS_fnc_call",0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;