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
    QGVAR(cooldown),
    "SLIDER",
    "Occupation Cooldown",
    COMPONENT_NAME,
    [
        60,
        3600,
        600,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(infCountCapital),
    "SLIDER",
    "Infantry Count in Capitals",
    COMPONENT_NAME,
    [
        1,
        60,
        30,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCountCapital),
    "SLIDER",
    "Land Vehicle Count in Capitals",
    COMPONENT_NAME,
    [
        0,
        3,
        2,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(airCountCapital),
    "SLIDER",
    "Air Vehicle Count in Capitals",
    COMPONENT_NAME,
    [
        0,
        2,
        1,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(infCountCity),
    "SLIDER",
    "Infantry Count in Cities",
    COMPONENT_NAME,
    [
        1,
        40,
        20,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCountCity),
    "SLIDER",
    "Land Vehicle Count in Cities",
    COMPONENT_NAME,
    [
        0,
        2,
        1,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(airCountCity),
    "SLIDER",
    "Air Vehicle Count in Cities",
    COMPONENT_NAME,
    [
        0,
        1,
        0,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(infCountVillage),
    "SLIDER",
    "Infantry Count in Village",
    COMPONENT_NAME,
    [
        1,
        20,
        10,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCountVillage),
    "SLIDER",
    "Land Vehicle Count in Village",
    COMPONENT_NAME,
    [
        0,
        1,
        1,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(airCountVillage),
    "SLIDER",
    "Air Vehicle Count in Village",
    COMPONENT_NAME,
    [
        0,
        1,
        0,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
