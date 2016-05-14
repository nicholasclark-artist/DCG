/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define DEBUG_VAR(LOC) format ["%1_%2_debug",ADDON,LOC]

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

PVEH_HINT addPublicVariableEventHandler {(_this select 1) call FUNC(hint)};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		{
			missionNamespace setVariable [AV_VAR(_x select 0),0 + random 5,false];
			false
		} count EGVAR(main,locations);

		if (CHECK_DEBUG) then {
			[{
				{
					if (CHECK_MARKER(DEBUG_VAR(_x select 0))) then {
						DEBUG_VAR(_x select 0) setMarkerText (format ["AV: %1", missionNamespace getVariable [AV_VAR(_x select 0),0]]);
					} else {
						_mrk = createMarker [DEBUG_VAR(_x select 0),_x select 1];
						_mrk setMarkerType "mil_dot";
						_mrk setMarkerText (format ["AV: %1", missionNamespace getVariable [AV_VAR(_x select 0),0]]);
					};
				} count EGVAR(main,locations);
			}, 10, []] call CBA_fnc_addPerFrameHandler;
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;