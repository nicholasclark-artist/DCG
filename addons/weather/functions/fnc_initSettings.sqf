/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

// @todo add settings: allow rain, allow fog
[
    QGVAR(enable),
    "CHECKBOX",
    format ["Enable %1", COMPONENT_NAME],
    COMPONENT_NAME,
    true,
    true,
    {[QGVAR(enable),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(month),
    "LIST",
    "Month",
    COMPONENT_NAME,
    [
        [-1,1,2,3,4,5,6,7,8,9,10,11,12],
        ["Random","January","February","March","April","May","June","July","August","September","October","November","December"],
        0
    ],
    true,
    {[QGVAR(month),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(time),
    "SLIDER",
    ["Time of Day","Hour of the day in 24hr format. A random hour will be set if -1 is selected."],
    COMPONENT_NAME,
    [
        -1,
        23,
        -1,
        0
    ],
    true,
    {[QGVAR(time),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;
