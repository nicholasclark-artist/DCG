/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// eventhandlers
["CBA_settingsInitialized", {
    if !(GVAR(enable)) exitWith {LOG(MSG_EXIT)};

    // headless client setup
    if (isServer) then {
        // disable if ace headless addon detected 
        if (GVAR(enableHC) && {!(CHECK_ADDON_1(acex_headless))}) then {
            ["AllVehicles", "init", FUNC(sendToHC), nil, nil, true] call CBA_fnc_addClassEventHandler;

            addMissionEventHandler ["HandleDisconnect", {
                if (_this#0 isEqualTo GVAR(HC)) then {
                    GVAR(HC) = objNull;
                    INFO("headless client disconnected");
                };
            }];
        };
    } else {
        [QGVAR(HCConnected), [player]] call CBA_fnc_serverEvent;
    };

    // headless client exit 
    if (!isServer) exitWith {};

    // eventhandlers
    [QGVAR(saveData), FUNC(saveData)] call CBA_fnc_addEventHandler;

    [QGVAR(deleteData), {
        profileNamespace setVariable [QGVAR(saveData),nil];
        saveProfileNamespace;   
    }] call CBA_fnc_addEventHandler;

    [QGVAR(cleanup), {_this call FUNC(cleanup)}] call CBA_fnc_addEventHandler;

    [QGVAR(debugMarkers), {
        if (GVAR(debug)) then {[1] call FUNC(debug)};
    }] call CBA_fnc_addEventHandler;

    // per frame handlers
    [
        {if (GVAR(autoSave)) then {call FUNC(saveData)}}, 
        1800
    ] call CBA_fnc_addPerFrameHandler;
        
    [FUNC(handleCleanup), 120] call CBA_fnc_addPerFrameHandler;

    // call debug if macro enabled
    [DEBUG_ADDON] call FUNC(debug);

    // load main addon data 
    call FUNC(handleLoadData);

    // setup clients
    remoteExecCall [QFUNC(initClient),0,true];

    MAIN_ADDON = true;
    publicVariable QUOTE(MAIN_ADDON);

    TRACE_1("",MAIN_ADDON);
}] call CBA_fnc_addEventHandler;