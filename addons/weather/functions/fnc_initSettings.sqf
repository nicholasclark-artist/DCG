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
    {},
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
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(hour),
    "SLIDER",
    ["Hour","Hour of the day in 24hr format. A random hour will be set if the value is below 0."],
    COMPONENT_NAME,
    [
        -1,
        23,
        -1,
        0
    ],
    true,
    {
        GVAR(hour) = floor _this;
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
    QGVAR(cloudsOverride),
    "SLIDER",
    ["Probability of Clouds","A measure of the probability that mostly cloudy or overcast conditions will occur. The probability is map dependent if the value is below 0."],
    COMPONENT_NAME,
    [
        -1,
        1,
        -1,
        2
    ],
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(precipitationOverride),
    "SLIDER",
    ["Probability of Precipitation","A measure of the probability that precipitation will occur. The probability is map dependent if the value is below 0."],
    COMPONENT_NAME,
    [
        -1,
        1,
        -1,
        2
    ],
    true,
    {},
    true
] call CBA_Settings_fnc_init;