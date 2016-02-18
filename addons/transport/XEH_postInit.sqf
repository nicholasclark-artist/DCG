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
			if (hasInterface) then {
				// fix "respawn on start" missions
				_time = diag_tickTime;
				waitUntil {diag_tickTime > _time + 10 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}};
				[QUOTE(ADDON),"Transport","",QUOTE(call FUNC(canCallTransport)),QUOTE(call FUNC(getChildren)),player,1] call EFUNC(main,setAction);
			};
		} remoteExec ["BIS_fnc_call",0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;