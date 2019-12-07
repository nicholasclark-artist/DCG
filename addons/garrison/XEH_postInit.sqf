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

    [QGVAR(updateScore), {
        // update ao score
        (_this select 0) setVariable [QGVAR(score),((_this select 0) getVariable [QGVAR(score),0]) + (_this select 1)];

        // update average score
        GVAR(score) = 0;

        [GVAR(areas),{
            GVAR(score) = GVAR(score) + (_value getVariable [QGVAR(score),0]);
        }] call CBA_fnc_hashEachPair;

        GVAR(score) = GVAR(score) / (count ([GVAR(areas)] call CBA_fnc_hashKeys));
    }] call CBA_fnc_addEventHandler;

    [{
        call FUNC(init);
    }, [], 10] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
