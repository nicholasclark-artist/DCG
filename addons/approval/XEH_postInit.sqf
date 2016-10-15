/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

PVEH_QUESTION addPublicVariableEventHandler {[_this select 1] call FUNC(question)};
PVEH_HINT addPublicVariableEventHandler {[_this select 1] call FUNC(hint)};
PVEH_AVADD addPublicVariableEventHandler {(_this select 1) call EFUNC(approval,addValue);};

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
	 			[
	 				{!isNull player && {alive player}},
	 				{
	 					{
	 						_x call EFUNC(main,setAction);
	 					} forEach [
	 						[QUOTE(ADDON),"Approval","",QUOTE(true),""],
	 						[QUOTE(DOUBLES(ADDON,hint)),HINT_NAME,HINT_CODE,QUOTE(true),"",player,1,ACTIONPATH],
	 						[QUOTE(DOUBLES(ADDON,question)),QUESTION_NAME,QUESTION_CODE,QUOTE(true),"",player,1,ACTIONPATH]
	 					];
	 				}
	 			] call CBA_fnc_waitUntilAndExecute;

	 			[ADDON_TITLE, HINT_KEYID, HINT_NAME, compile HINT_CODE, ""] call CBA_fnc_addKeybind;
	 			[ADDON_TITLE, QUESTION_KEYID, QUESTION_NAME, compile QUESTION_CODE, ""] call CBA_fnc_addKeybind;
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