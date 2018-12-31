/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(isMultiplayer) exitWith {};

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {};

		call FUNC(init);

		PVEH_CREATE addPublicVariableEventHandler {[_this select 1] call FUNC(handleCreate)};
		PVEH_DELETE addPublicVariableEventHandler {[_this select 1] call FUNC(handleDelete)};
		PVEH_TRANSFER addPublicVariableEventHandler {(_this select 1) call FUNC(handleTransfer)};
		PVEH_ASSIGN addPublicVariableEventHandler {[GVAR(curator),_this select 1] call FUNC(handleAssign)};

		addMissionEventHandler ["HandleDisconnect",{
			if ((_this select 0) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
				unassignCurator GVAR(curator)
			};
			false
		}];

		_data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
				call FUNC(handleClient);
			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	}
] call CBA_fnc_waitUntilAndExecute;


