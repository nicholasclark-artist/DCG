/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define SET_PATROL \
	{ \
		if (_x isKindOf 'Man' && {_x isEqualTo leader group _x} && {!(_x getVariable ['dcg_isOnPatrol',-1] isEqualTo 1)}) then { \
			[units group _x,GVAR(range)*0.5,false] call EFUNC(main,setPatrol); \
			_x addEventHandler ['Local',{ \
				if (_this select 1) then { \
					_x setVariable ['dcg_isOnPatrol',0]; \
					[units group (_this select 0),GVAR(range)*0.5,false] call EFUNC(main,setPatrol); \
				}; \
			}]; \
		}; \
	} forEach (curatorEditableObjects GVAR(curator))

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

if (isNil QGVAR(curator)) exitWith { // curator must be initialized in mission
	LOG_DEBUG("Curator does not exist.");
};

unassignCurator GVAR(curator);

// eventhandlers
PVEH_DEPLOY addPublicVariableEventHandler {(_this select 1) call FUNC(setup)};
PVEH_REQUEST addPublicVariableEventHandler {(_this select 1) call FUNC(requestHandler)};
PVEH_REASSIGN addPublicVariableEventHandler {(_this select 1) assignCurator GVAR(curator)};
addMissionEventHandler ["HandleDisconnect",{
	if ((_this select 2) isEqualTo GVAR(UID)) then {unassignCurator GVAR(curator)};
	false
}];

[{
	if (DOUBLES(PREFIX,main) && {time > 0}) exitWith { // must run after time == 0
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			[objNull,_data select 0,_data select 1] call FUNC(setup);
			{
				_veh = (_x select 0) createVehicle [0,0,0];
				_veh setDir (_x select 2);
				_veh setPosASL (_x select 1);
				_veh setVectorUp (_x select 3);
				GVAR(curator) addCuratorEditableObjects [[_veh],false];
				false
			} count (_data select 2);
		};

		{
			if (hasInterface) then {
				waitUntil {time > 5 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}}; // hack to fix "respawn on start" missions
				[QUOTE(ADDON),"Forward Operating Base","",QUOTE(true),QUOTE(call FUNC(getChildren)),player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]] call EFUNC(main,setAction);
				[QUOTE(DOUBLES(ADDON,patrol)),"Set FOB Groups on Patrol",QUOTE(SET_PATROL),QUOTE(player isEqualTo (getAssignedCuratorUnit GVAR(curator))),"",player,1,ACTIONPATH] call EFUNC(main,setAction);

				player addEventHandler ["respawn",{
					if ((getPlayerUID (_this select 0)) isEqualTo GVAR(UID)) then {
						[] spawn {
							sleep 5;
							missionNamespace setVariable [PVEH_REASSIGN,player];
							publicVariableServer PVEH_REASSIGN;
						};
					};
				}];
			};
		} remoteExec ["BIS_fnc_call",0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;