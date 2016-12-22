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
    QGVAR(spawnDist),
    "SLIDER",
    "Spawn Distance",
    COMPONENT_NAME,
    [
        100,
        1000,
        400,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(countCapital),
    "SLIDER",
    "Civilian Count in Capitals",
    COMPONENT_NAME,
    [
        0,
        20,
        15,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(countCity),
    "SLIDER",
    "Civilian Count in Cities",
    COMPONENT_NAME,
    [
        0,
        20,
        10,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(countVillage),
    "SLIDER",
    "Civilian Count in Villages",
    COMPONENT_NAME,
    [
        0,
        20,
        5,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehMaxCount),
    "SLIDER",
    "Max Vehicle Count",
    COMPONENT_NAME,
    [
        0,
        10,
        5,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCooldown),
    "SLIDER",
    "Vehicle Cooldown",
    COMPONENT_NAME,
    [
        300,
        3600,
        600,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
