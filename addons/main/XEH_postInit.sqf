/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// eventhandlers
[QGVARMAIN(settingsInitialized), {
    [{if (GVAR(autoSave)) then {call FUNC(saveData)}}, 1800, []] call CBA_fnc_addPerFrameHandler; // @todo start PFH after one cooldown cycle
    call FUNC(handleLoadData);
}] call CBA_fnc_addEventHandler;

[QGVAR(saveData), FUNC(saveData)] call CBA_fnc_addEventHandler;

[QGVAR(deleteData), {
    profileNamespace setVariable [QGVAR(saveData),nil];
    saveProfileNamespace;   
}] call CBA_fnc_addEventHandler;

[QGVAR(debugMarkers), {
    if (GVAR(debug)) then {[1] call FUNC(debug)};
}] call CBA_fnc_addEventHandler;

// per frame handlers
[FUNC(handleCleanup), 120, []] call CBA_fnc_addPerFrameHandler; // @todo start PFH after one cooldown cycle

if !(isNil {HEADLESSCLIENT}) then {
    [{
        {
            deleteGroup _x; // will only delete local empty groups
        } forEach allGroups;
    }, 120, []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler),owner HEADLESSCLIENT,false];
};

// setup clients
remoteExecCall [QFUNC(initClient),0,true];

MAIN_ADDON = true;
publicVariable QUOTE(MAIN_ADDON);