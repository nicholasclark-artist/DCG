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

[
    QGVAR(enable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    format ["Enable %1", COMPONENT_NAME], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
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
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(time),
    "SLIDER",
    ["Time of Day","Hour of the day in 24hr format."],
    COMPONENT_NAME,
    [
        -1,
        23,
        -1,
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;
