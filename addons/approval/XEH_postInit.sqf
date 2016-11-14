/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

CHECK_ADDON;

PVEH_QUESTION addPublicVariableEventHandler {(_this select 1) call FUNC(handleQuestion)};
PVEH_HINT addPublicVariableEventHandler {[_this select 1] call FUNC(handleHint)};
PVEH_AVADD addPublicVariableEventHandler {(_this select 1) call FUNC(addValue)};

[
	{DOUBLES(PREFIX,main)},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[{
			[FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler
		}, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

		[[],{
			if (hasInterface) then {
                call FUNC(handleClient);
			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];

		{
			_mrk = createMarker [LOCATION_DEBUG_ID(_x select 0),_x select 1];
			_mrk setMarkerType "mil_dot";
			_mrk setMarkerText LOCATION_DEBUG_TEXT(_x select 0);

			[_mrk] call EFUNC(main,setDebugMarker);

			false
		} count EGVAR(main,locations);
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
