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

    // make sure dynamic sim is running
    enableDynamicSimulationSystem true;

    [QGVAR(enableGroup),{[_this] call FUNC(enable)}] call CBA_fnc_addEventHandler;
    [QGVAR(disableGroup),{[_this] call FUNC(disable)}] call CBA_fnc_addEventHandler;

    ["CAManBase","init",FUNC(handleGroups),nil,nil,true] call CBA_fnc_addClassEventHandler;
}] call CBA_fnc_addEventHandler;