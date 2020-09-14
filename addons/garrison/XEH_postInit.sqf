/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// headless client exit
if (!isServer) exitWith {};

["CBA_settingsInitialized",{
    if (!EGVAR(main,enable) || {!GVAR(enable)}) exitWith {LOG(MSG_EXIT)};

    // @todo clear null groups
    [QGVAR(updateGroups),{
        private _groups = (_this select 0) getVariable [QGVAR(groups),[]];
        _groups pushBack (_this select 1);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(updateScore),{
        // update ao score
        (_this select 0) setVariable [QGVAR(score),((_this select 0) getVariable [QGVAR(score),0]) + (_this select 1)];

        // update average score
        GVAR(score) = 0;

        [GVAR(areas),{
            GVAR(score) = GVAR(score) + (_value getVariable [QGVAR(score),0]);
        }] call CBA_fnc_hashEachPair;

        GVAR(score) = GVAR(score) / (count ([GVAR(areas)] call CBA_fnc_hashKeys));
    }] call CBA_fnc_addEventHandler;

    // runs once intel gathered
    [QGVAR(intel),{
        params ["_intel","_player"];

        private _type = parseNumber (_intel isEqualTo GVAR(intel));

        [_intel,_player,_type] call FUNC(handleIntel);
    }] call CBA_fnc_addEventHandler;

    [FUNC(init),[],10] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
