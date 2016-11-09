/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

PVEH_CREATE addPublicVariableEventHandler {[_this select 1] call FUNC(handleCreate)};
PVEH_DELETE addPublicVariableEventHandler {[_this select 1] call FUNC(handleDelete)};
PVEH_TRANSFER addPublicVariableEventHandler {(_this select 1) call FUNC(handleTransfer)};
PVEH_ASSIGN addPublicVariableEventHandler {(_this select 1) assignCurator GVAR(curator)};

addMissionEventHandler ["HandleDisconnect",{
	if ((_this select 0) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
        unassignCurator GVAR(curator)
    };
	false
}];

[
	{DOUBLES(PREFIX,main)},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
				if ([player] call FUNC(canAddAction)) then {
	 				call FUNC(handleClient);
				};

	 			[ADDON_TITLE, CREATE_ID, CREATE_NAME, {CREATE_KEYCODE}, ""] call CBA_fnc_addKeybind;
                [ADDON_TITLE, DELETE_ID, DELETE_NAME, {DELETE_KEYCODE}, ""] call CBA_fnc_addKeybind;
	 			[ADDON_TITLE, TRANSFER_ID, TRANSFER_NAME, {TRANSFER_KEYCODE}, ""] call CBA_fnc_addKeybind;
	 			[ADDON_TITLE, CONTROL_ID, CONTROL_NAME, {CONTROL_KEYCODE}, ""] call CBA_fnc_addKeybind;
	 			// [ADDON_TITLE, PATROL_ID, PATROL_NAME, {PATROL_KEYCODE}, ""] call CBA_fnc_addKeybind;
	 			[ADDON_TITLE, RECON_ID, RECON_NAME, {RECON_KEYCODE}, ""] call CBA_fnc_addKeybind;
	 			[ADDON_TITLE, BUILD_ID, BUILD_NAME, {BUILD_KEYCODE}, "", [DIK_DOWN, [true, false, false]]] call CBA_fnc_addKeybind;
			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	}
] call CBA_fnc_waitUntilAndExecute;

INFO_1("Curator list %1",allCurators);

ADDON = true;
