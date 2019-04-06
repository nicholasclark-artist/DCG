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

    // eventhandlers
    [QGVAR(commandeer), {[_this] call FUNC(commandeer)}] call CBA_fnc_addEventHandler;
    
    // must run before handlers
    call FUNC(parseLocations);

    // handlers
    [FUNC(handleLocation), 2] call CBA_fnc_addPerFrameHandler;
    [FUNC(handleVehicle), GVAR(vehCooldown)] call CBA_fnc_addPerFrameHandler;
    [FUNC(handleAnimal), 300] call CBA_fnc_addPerFrameHandler;
}] call CBA_fnc_addEventHandler;