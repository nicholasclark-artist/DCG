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

    [{
        [FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
    }, [], GVAR(cooldown)] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
