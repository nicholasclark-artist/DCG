/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

unassignCurator GVAR(curator);

PVEH_DEPLOY addPublicVariableEventHandler {(_this select 1) call FUNC(setup)};
PVEH_REQUEST addPublicVariableEventHandler {(_this select 1) call FUNC(handleRequest)};
PVEH_REASSIGN addPublicVariableEventHandler {(_this select 1) assignCurator GVAR(curator)};
addMissionEventHandler ["HandleDisconnect",{
	if ((_this select 2) isEqualTo GVAR(UID)) then {unassignCurator GVAR(curator)};
	false
}];

{
	[TITLE, KEY_ID, KEY_NAME, {call FUNC(handleKey)}, "", [DIK_Y, [true, false, false]]] call CBA_fnc_addKeybind;
} remoteExecCall [QUOTE(BIS_fnc_call),0,true];

[{
	if (DOUBLES(PREFIX,main) && {time > 0}) exitWith {
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

				if (typeOf _veh in FOB_HQ) then {
					[true,getPosASL _veh] call FUNC(recon);
				};
				false
			} count (_data select 2);

			GVAR(AVBonus) = (_data select 3);
		};

		[QUOTE(ADDON),"Forward Operating Base","",QUOTE(true),QUOTE(call FUNC(getChildren))] remoteExecCall [QEFUNC(main,setAction), 0, true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;