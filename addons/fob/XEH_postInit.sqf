/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

["CBA_settingsInitialized", {
    if (!EGVAR(main,enable) || {!GVAR(enable)}) exitWith {LOG(MSG_EXIT)};

    [QGVAR(create), {_this call FUNC(handleCreate)}] call CBA_fnc_addEventHandler;
    [QGVAR(delete), {call FUNC(handleDelete)}] call CBA_fnc_addEventHandler;
    [QGVAR(transfer), {_this call FUNC(handleTransfer)}] call CBA_fnc_addEventHandler;
    [QGVAR(assign), {_this call FUNC(handleAssign)}] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["HandleDisconnect",{
        if ((_this select 0) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
            unassignCurator GVAR(curator)
        };
        false
    }];

    call FUNC(init);
    call FUNC(handleLoadData);
    remoteExecCall [QFUNC(initClient),0,true];
}] call CBA_fnc_addEventHandler;