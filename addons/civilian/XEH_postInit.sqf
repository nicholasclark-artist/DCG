/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit 
if (!isServer) exitWith {};

[QGVARMAIN(settingsInitialized), {
    // convert to array and format
    GVAR(blacklist) = GVAR(blacklist) splitString ",";
    GVAR(blacklist) = GVAR(blacklist) apply {toLower _x};

    // get locations for unit spawns
    private ["_locations","_locals","_arr"];

    _locations = [];
    _locals = [];

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
            _locals pushBack _arr;
        }
    ] call CBA_fnc_hashEachPair;

    // remove unsuitable locals
    _locals = _locals select {
        toLower (_x#0) find "pier" < 0 && 
        {toLower (_x#0) find "airbase" < 0} &&
        {toLower (_x#0) find "airfield" < 0} &&
        {toLower (_x#0) find "terminal" < 0}
    };
 
    _locations append _locals;

    [FUNC(handleVehicle), GVAR(vehCooldown)] call CBA_fnc_addPerFrameHandler;
    [FUNC(handleAnimal), 300] call CBA_fnc_addPerFrameHandler;

    // 'waitUntilAndExecute', possible fix for civ module init failing sometimes
    [{CBA_missionTime > 1}, FUNC(handleUnit), _locations] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;