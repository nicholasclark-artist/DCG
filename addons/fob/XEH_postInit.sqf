/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

[
    {MAIN_ADDON && {CHECK_POSTBRIEFING}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {
            LOG(MSG_EXIT);
        };
        
        // eventhandlers
        [QGVAR(create), {_this call FUNC(handleCreate)}] call CBA_fnc_addEventHandler;
        [QGVAR(delete), FUNC(handleDelete)] call CBA_fnc_addEventHandler;
        [QGVAR(transfer), {_this call FUNC(handleTransfer)}] call CBA_fnc_addEventHandler;
        [QGVAR(assign), {_this call FUNC(handleAssign)}] call CBA_fnc_addEventHandler;

        addMissionEventHandler ["HandleDisconnect",{
            if ((_this select 0) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
                unassignCurator GVAR(curator)
            };
            false
        }];

        // load data from server profile
        call FUNC(handleLoadData);

        call FUNC(init);

        // setup clients
        remoteExecCall [QFUNC(handleClient),0,true];
    }
] call CBA_fnc_waitUntilAndExecute;


