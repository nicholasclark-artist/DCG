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

PVEH_HINT addPublicVariableEventHandler {[_this select 1] call FUNC(hint)};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			{
				_name = _x select 0;
				_value = _x select 1;

				missionNamespace setVariable [_name,_value,false];
				false
			} count _data;
		} else {
			{
				missionNamespace setVariable [AV_VAR(_x select 0),AV_MAX*0.1,false];
				false
			} count EGVAR(main,locations);
		};

		[
			{!isNull player && {alive player}},
			{
				{
					_x call EFUNC(main,setAction);
				} forEach [
					[QUOTE(ADDON),"Approval","",QUOTE(true),""],
					[QUOTE(DOUBLES(ADDON,hint)),"Check Approval in Region",format ["%1 = player; publicVariableServer '%1'", PVEH_HINT],QUOTE(true),"",player,1,ACTIONPATH],
					[QUOTE(DOUBLES(ADDON,question)),"Question Nearby Person",QUOTE(call FUNC(question)),QUOTE(true),"",player,1,ACTIONPATH]
				];
			}
		] remoteExecCall [QUOTE(CBA_fnc_waitUntilAndExecute), 0, true];

		call FUNC(handleHostile);

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
			}, 5, []] call CBA_fnc_addPerFrameHandler;
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;

