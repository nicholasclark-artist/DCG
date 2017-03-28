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
    QGVAR(multiplier),
    "LIST",
    ["Civilian Count","Amount of civilian units spawned in a location."],
    COMPONENT_NAME,
    [
        [1,1.5],
        ["Low","High"],
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(spawnDist),
    "SLIDER",
    ["Spawn Distance","Distance from location center that units will spawn."],
    COMPONENT_NAME,
    [
        300,
        1000,
        400,
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehMaxCount),
    "SLIDER",
    ["Max Vehicle Count","Max number of active civilian vehicles."],
    COMPONENT_NAME,
    [
        0,
        10,
        5,
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCooldown),
    "SLIDER",
    ["Vehicle Cooldown","Time in seconds between potential vehicle spawns."],
    COMPONENT_NAME,
    [
        300,
        3600,
        600,
        0
    ],
    false,
    {}
] call CBA_Settings_fnc_init;
