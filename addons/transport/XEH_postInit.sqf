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
        [QGVAR(request), {_this call FUNC(handleRequest)}] call CBA_fnc_addEventHandler;

        // setup client
        remoteExecCall [QFUNC(handleClient), 0, true];
    }
] call CBA_fnc_waitUntilAndExecute;