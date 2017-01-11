/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

call FUNC(init);

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
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
				call FUNC(handleClient);
			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
