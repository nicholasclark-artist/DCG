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
    QGVAR(cooldown),
    "SLIDER",
    ["Spawn Cooldown","Time in seconds between potential patrol spawns."],
    COMPONENT_NAME,
    [
        60,
        3600,
        600,
        0
    ],
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(groupLimit),
    "SLIDER",
    ["Group Limit","Maximum number of active patrol groups."],
    COMPONENT_NAME,
    [
        1,
        16,
        4,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehicleProbability),
    "SLIDER",
    ["Vehicle Probability","Probability of spawned patrol being a vehicle unit."],
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
