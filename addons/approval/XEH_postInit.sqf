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
PVEH_QUESTION addPublicVariableEventHandler {[_this select 1] call FUNC(onCivQuestion)};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			{
				missionNamespace setVariable _x;
				false
			} count _data;
		} else {
			{
				missionNamespace setVariable [AV_VAR(_x select 0),0 + round random 5,false];
				false
			} count EGVAR(main,locations);
		};

		{
			if (hasInterface) then {
				// fix "respawn on start" missions
				_time = diag_tickTime;
				waitUntil {diag_tickTime > _time + 10 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}};
				[QUOTE(ADDON),"Approval","",QUOTE(true),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]] call EFUNC(main,setAction);
				[QUOTE(DOUBLES(ADDON,hint)),"Check Approval in Region",format ["%1 = player; publicVariableServer '%1'", PVEH_HINT],QUOTE(true),"",player,1,ACTIONPATH] call EFUNC(main,setAction);
				[QUOTE(DOUBLES(ADDON,question)),"Question Nearby Civilians",format ["%1 = player; publicVariableServer '%1'", PVEH_QUESTION],QUOTE(true),"",player,1,ACTIONPATH] call EFUNC(main,setAction);
			};
		} remoteExec ["BIS_fnc_call",0,true];

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
