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

    // update groups for given location
    [QGVAR(updateGroups),{
        private _groups = (_this select 0) getVariable [QGVAR(groups),[]];

        {
            _groups deleteAt (_groups find _x);
            _x call CBA_fnc_deleteEntity;
        } forEach (_groups select {isNull _x});

        _groups pushBack (_this select 1);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(reinit),{
        ERROR("init failed, retry after cooldown");

        [GVAR(outposts),{
            [_key,true] call FUNC(removeOutpost);
        }] call CBA_fnc_hashEachPair;

        [GVAR(areas),{
            [_key,true] call FUNC(removeArea);
        }] call CBA_fnc_hashEachPair;

        // @todo remove comms
        [FUNC(init),[],10] call CBA_fnc_waitAndExecute;
    }] call CBA_fnc_addEventHandler;

    // @todo add reinforcement EH to all outpost units
    // @todo add switch EH to comm array
    [QGVAR(disableComm),{
        params ["_key","_switch"];

        // @todo play power down sfx
        _switch animateSource ["switchposition",0];
    }] call CBA_fnc_addEventHandler;

    // runs once intel gathered
    [QGVAR(intel),{
        params ["_intel"];

        private _type = parseNumber (_intel isEqualTo GVAR(intel));

        [_intel,_type] call FUNC(handleIntel);
    }] call CBA_fnc_addEventHandler;

    // init addon
    [FUNC(init),[],10] call CBA_fnc_waitAndExecute;

    // run handlers
    [{
        [FUNC(handlePatrol),300,[]] call CBA_fnc_addPerFrameHandler;
    },[],60] call CBA_fnc_waitAndExecute;
}] call CBA_fnc_addEventHandler;
