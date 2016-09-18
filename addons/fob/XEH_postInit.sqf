/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

unassignCurator GVAR(curator);

PVEH_DEPLOY addPublicVariableEventHandler {(_this select 1) call FUNC(setup)};
PVEH_REQUEST addPublicVariableEventHandler {(_this select 1) call FUNC(handleRequest)};
PVEH_REASSIGN addPublicVariableEventHandler {(_this select 1) assignCurator GVAR(curator)};
PVEH_DELETE addPublicVariableEventHandler {
	{_x call EFUNC(main,cleanup)} forEach (curatorEditableObjects GVAR(curator));
	[getPosASL GVAR(anchor),AV_FOB*-1] call EFUNC(approval,addValue);
	unassignCurator GVAR(curator);
	[false] call FUNC(recon);
	deleteVehicle GVAR(anchor);

	{
		deleteLocation GVAR(location);
	} remoteExecCall [QUOTE(BIS_fnc_call), 0, false];
};

addMissionEventHandler ["HandleDisconnect",{
	if ((_this select 2) isEqualTo GVAR(UID)) then {unassignCurator GVAR(curator)};
	false
}];

[{
	if (DOUBLES(PREFIX,main) && {time > 0}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			[_data select 0,_data select 1] call FUNC(setup);
			{
				_veh = (_x select 0) createVehicle [0,0,0];
				_veh setDir (_x select 2);
				_veh setPosASL (_x select 1);
				_veh setVectorUp (_x select 3);
				GVAR(curator) addCuratorEditableObjects [[_veh],false];
				false
			} count (_data select 2);

			//GVAR(AVBonus) = (_data select 3);
		};

		{
			[QUOTE(ADDON),"Forward Operating Base","",QUOTE(true),QUOTE(call FUNC(getChildren))] call EFUNC(main,setAction);

			[ADDON_TITLE, DEPLOY_ID, DEPLOY_NAME, {DEPLOY_KEYCODE}, ""] call CBA_fnc_addKeybind;
			[ADDON_TITLE, REQUEST_ID, REQUEST_NAME, {REQUEST_KEYCODE}, ""] call CBA_fnc_addKeybind;
			[ADDON_TITLE, DISMANTLE_ID, DISMANTLE_NAME, {DISMANTLE_KEYCODE}, ""] call CBA_fnc_addKeybind;
			[ADDON_TITLE, PATROL_ID, PATROL_NAME, {PATROL_KEYCODE}, ""] call CBA_fnc_addKeybind;
			[ADDON_TITLE, RECON_ID, RECON_NAME, {RECON_KEYCODE}, ""] call CBA_fnc_addKeybind;
			[ADDON_TITLE, BUILD_ID, BUILD_NAME, {BUILD_KEYCODE}, "", [DIK_DOWN, [true, false, false]]] call CBA_fnc_addKeybind;

			player addEventHandler ["Respawn",{
				if ((getPlayerUID (_this select 0)) isEqualTo GVAR(UID)) then {
					[
						{
							missionNamespace setVariable [PVEH_REASSIGN,player];
							publicVariableServer PVEH_REASSIGN;
						},
						[],
						5
					] call CBA_fnc_waitAndExecute;
				};
			}];
		} remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;