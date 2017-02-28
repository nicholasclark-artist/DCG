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
    format ["Enable %1", toUpper QUOTE(PREFIX)], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(playerSide),
    "LIST",
    ["Player Side","Must be the same side as editor placed playable units."],
    COMPONENT_NAME,
    [
        [EAST,WEST,RESISTANCE],
        ["EAST","WEST","RESISTANCE"],
        1
    ],
    false,
    {
        if (isServer) then {
            publicVariable QGVAR(playerSide);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(enemySide),
    "LIST",
    ["Enemy Side","Cannot be the same as player side."],
    COMPONENT_NAME,
    [
        [EAST,WEST,RESISTANCE],
        ["EAST","WEST","RESISTANCE"],
        0
    ],
    false,
    {
        if (isServer) then {
            publicVariable QGVAR(enemySide);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(loadData),
    "CHECKBOX",
    ["Load Mission Data","Load mission data saved to server profile."],
    COMPONENT_NAME,
    false,
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(autoSave),
    "CHECKBOX",
    ["Autosave Mission Data","Autosave mission data to server profile."],
    COMPONENT_NAME,
    false,
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(baseRadius),
    "SLIDER",
    ["Main Operating Base Radius","Base radius."],
    COMPONENT_NAME,
    [
        100,
        2000,
        (worldSize*0.05) min 2000,
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(baseSafezone),
    "CHECKBOX",
    ["Main Operating Base Safezone","Deletes enemy units within base radius."],
    COMPONENT_NAME,
    true,
    false,
    {}
] call CBA_Settings_fnc_init;
