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
    ["Patrol Spawn Cooldown","Time in seconds between potential patrol spawns."],
    COMPONENT_NAME,
    [
        300,
        3600,
        900,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(groupsMaxCount),
    "SLIDER",
    ["Max Group Count","Max number of active patrol groups."],
    COMPONENT_NAME,
    [
        1,
        10,
        5,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehChance),
    "SLIDER",
    ["Vehicle Spawn Chance","Probability of spawned patrol being a vehicle unit."],
    COMPONENT_NAME,
    [
        0,
        1,
        0.25,
        2
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
