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

    [QGVAR(reinit),{
        [GVAR(outposts),{
            [_key,true] call FUNC(removeOutpost);
        }] call CBA_fnc_hashEachPair;

        [GVAR(areas),{
            [_key,true] call FUNC(removeArea);
        }] call CBA_fnc_hashEachPair;

        [FUNC(init),[],20] call CBA_fnc_waitAndExecute;
        WARNING("init failed, retry after cooldown")
    }] call CBA_fnc_addEventHandler;

    // @todo clear null groups
    [QGVAR(updateGroups),{
        private _groups = (_this select 0) getVariable [QGVAR(groups),[]];
        _groups pushBack (_this select 1);
    }] call CBA_fnc_addEventHandler;

    // runs once intel gathered
    [QGVAR(intel),{
        params ["_intel"];

        private _type = parseNumber (_intel isEqualTo GVAR(intel));

        [_intel,_type] call FUNC(handleIntel);
    }] call CBA_fnc_addEventHandler;

    [FUNC(init),[],10] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
