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

    [QGVAR(updateUnitCount), {
        (_this select 0) setVariable [QGVAR(unitCountCurrent),((_this select 0) getVariable [QGVAR(unitCountCurrent),0]) + (_this select 1)];
    }] call CBA_fnc_addEventHandler;

    [QGVAR(updateGroups), {
        private _groups = (_this select 0) getVariable [QGVAR(groups),[]];
        _groups pushBack (_this select 1);
    }] call CBA_fnc_addEventHandler;

    [{
        call FUNC(setArea);
        [FUNC(handleArea), 30] call CBA_fnc_addPerFrameHandler;
    }, [], 10] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
