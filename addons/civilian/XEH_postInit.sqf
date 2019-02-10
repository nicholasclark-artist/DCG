/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

[QGVARMAIN(settingsInitialized), {
    // convert to array and format
    GVAR(blacklist) = GVAR(blacklist) splitString ",";
    GVAR(blacklist) = GVAR(blacklist) apply {toLower _x};

    // get locations for unit spawns
    private _locations =+ EGVAR(main,locations);
    private _locals =+ EGVAR(main,locals);

    // remove unsuitable locals
    _locals = _locals select {
        toLower (_x select 0) find "pier" < 0 && 
        {toLower (_x select 0) find "airbase" < 0} &&
        {toLower (_x select 0) find "airfield" < 0} &&
        {toLower (_x select 0) find "terminal" < 0}
    };

    _locations append _locals;

    if !(GVAR(allowSafezone)) then {
        // remove locations in safezones
        GVAR(blacklist) append (_locations select {[_x select 1] call EFUNC(main,inSafezones)});
    };

    [FUNC(handleVehicle), GVAR(vehCooldown)] call CBA_fnc_addPerFrameHandler;
    [FUNC(handleAnimal), 300] call CBA_fnc_addPerFrameHandler;

    // 'waitUntilAndExecute', possible fix for civ module init failing sometimes
    [{CBA_missionTime > 1}, FUNC(handleUnit), _locations] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addEventHandler;

