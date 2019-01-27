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
    QGVAR(iMonth),
    "LIST",
    "Month",
    COMPONENT_NAME,
    [
        [-1,1,2,3,4,5,6,7,8,9,10,11,12],
        ["Random","January","February","March","April","May","June","July","August","September","October","November","December"],
        0
    ],
    true,
    {[QGVAR(iMonth),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(iHour),
    "SLIDER",
    ["Hour","Hour of the day in 24hr format. A random hour will be set if -1 is selected."],
    COMPONENT_NAME,
    [
        -1,
        23,
        -1,
        0
    ],
    true,
    {
        GVAR(iHour) = floor _this; 
        [QGVAR(iHour),floor _this] call EFUNC(main,handleSettingChange);
    },
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(variance),
    "SLIDER",
    ["Forecast Variance","Determines how far the weather forecast will deviate from the initial weather."],
    COMPONENT_NAME,
    [
        1,
        5,
        1,
        2
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(precipitationOverride),
    "SLIDER",
    ["Probability of Precipitation","A measure of the probability that precipitation will occur. The probability will be map dependent if -1 is selected."],
    COMPONENT_NAME,
    [
        -1,
        1,
        -1,
        0
    ],
    true,
    {[QGVAR(precipitationOverride),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;