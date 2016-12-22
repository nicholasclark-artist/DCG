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
    QGVAR(enemySide),
    "LIST",
    "Enemy Side (MUST NOT BE PLAYER SIDE)",
    COMPONENT_NAME,
    [
        [EAST,WEST,RESISTANCE],
        ["EAST","WEST","RESISTANCE"],
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(loadData),
    "CHECKBOX",
    "Load Mission Data",
    COMPONENT_NAME,
    false,
    true,
    {
        if (GVAR(loadData)) then {
        	call FUNC(loadData);
        };
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(autoSave),
    "CHECKBOX",
    "Autosave Mission Data",
    COMPONENT_NAME,
    false,
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(baseRadius),
    "SLIDER",
    "Main Operating Base Radius",
    COMPONENT_NAME,
    [
        100,
        3000,
        (worldSize*0.055) min 3000,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(baseSafezone),
    "CHECKBOX",
    "Main Operating Base Safezone",
    COMPONENT_NAME,
    true,
    true,
    {}
] call CBA_Settings_fnc_init;
