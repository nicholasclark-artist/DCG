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
    
    // convert to array and format
    GVAR(blacklist) = GVAR(blacklist) splitString ",";
    GVAR(blacklist) = GVAR(blacklist) apply {toLower _x};

    // get locations for unit spawns
    private ["_locations","_arr"];

    _locations = [];

    [
        EGVAR(main,locations),
        {
            _arr = [];
            _arr pushBack _key;
            _arr append _value;
            _locations pushBack _arr;
        }
    ] call CBA_fnc_hashEachPair;

    [
        EGVAR(main,locals),
        {
            _arr = [];
            _arr pushBack _key;
            _arr append _value;
            _locations pushBack _arr;
        }
    ] call CBA_fnc_hashEachPair;

    [FUNC(handleVehicle), GVAR(vehCooldown)] call CBA_fnc_addPerFrameHandler;
    [FUNC(handleAnimal), 300] call CBA_fnc_addPerFrameHandler;

    // 'waitUntilAndExecute', possible fix for civ module init failing sometimes
    [{CBA_missionTime > 1}, FUNC(handleUnit), _locations] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;