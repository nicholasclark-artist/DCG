/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

[
    {MAIN_ADDON && {CHECK_INGAME}},
    {
        if (!(EGVAR(main,enable)) || {!(GVAR(enable))}) exitWith {
            LOG(MSG_EXIT);
        };

        // eventhandlers
        [QGVAR(question), {_this call FUNC(handleQuestion)}] call CBA_fnc_addEventHandler;
        [QGVAR(stop), {_this call FUNC(handleStop)}] call CBA_fnc_addEventHandler;
        [QGVAR(hint), {_this call FUNC(handleHint)}] call CBA_fnc_addEventHandler;
        [QGVAR(add), {
            _this call FUNC(addValue);
            TRACE_1("Client add value",_this);
        }] call CBA_fnc_addEventHandler;

        // load data from server profile
        call FUNC(handleLoadData);

        // start hostile handler after one cooldown cycle
        [{
            [FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;
        }, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

        // setup clients
        remoteExecCall [QFUNC(handleClient),0,true];
    }
] call CBA_fnc_waitUntilAndExecute;