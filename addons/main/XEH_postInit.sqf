/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isMultiplayer || {!isServer} || {!(GVAR(enable))}) exitWith {
    // set true on exit, so other addons can exit postInit
    MAIN_ADDON = true;
    publicVariable QUOTE(MAIN_ADDON);

    LOG(MSG_EXIT);
};

// save event handlers
[QGVAR(saveData), FUNC(saveData)] call CBA_fnc_addEventHandler;
[QGVAR(deleteData), {
    profileNamespace setVariable [QGVAR(saveData),nil];
    saveProfileNamespace;   
}] call CBA_fnc_addEventHandler;

// debug event handlers 
[QGVAR(debugMarkers), {
    if (GVAR(debug)) then {
        [1] call FUNC(debug);
    };
}] call CBA_fnc_addEventHandler;

// per frame handlers
[FUNC(handleCleanup), 120, []] call CBA_fnc_addPerFrameHandler;

if !(isNil {HEADLESSCLIENT}) then {
    [{
        {
            deleteGroup _x; // will only delete local empty groups
        } forEach allGroups;
    }, 120, []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler),owner HEADLESSCLIENT,false];
};

// populate location array 
call FUNC(setMapLocations);

// create world size position grid
GVAR(grid) = [EGVAR(main,center),worldSize/round(worldSize/1000),worldSize,0,0,0] call FUNC(findPosGrid);

// setup clients
remoteExecCall [QFUNC(handleClient),0,true];

// everything that needs to run after CBA settings are adjusted (post briefing)
[
    {CHECK_INGAME},
    {
        // autosave handler 
        [{
            if (GVAR(autoSave)) then {call FUNC(saveData)};
        }, 1800, []] call CBA_fnc_addPerFrameHandler;

        // load saved data
        call FUNC(handleLoadData);
    }
] call CBA_fnc_waitUntilAndExecute;

MAIN_ADDON = true;
publicVariable QUOTE(MAIN_ADDON);