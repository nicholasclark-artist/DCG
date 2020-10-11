/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define CATEGORY_DYNPAT [COMPONENT_NAME,"Dynamic Patrols"]

[
    QGVAR(enable),
    "CHECKBOX",
    format ["Enable %1",COMPONENT_NAME],
    COMPONENT_NAME,
    true,
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(cooldown),
    "SLIDER",
    ["AO Cooldown","Time in seconds between AO spawns."],
    COMPONENT_NAME,
    [
        0,
        3600,
        120,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(countCoef),
    "SLIDER",
    ["Enemy Count Multiplier",""],
    COMPONENT_NAME,
    [
        0,
        1,
        0.75,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(enableExternalPatrols),
    "CHECKBOX",
    ["External Patrols","Enable dynamic patrols outside areas of operation."],
    CATEGORY_DYNPAT,
    false,
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(vehicleProbability),
    "SLIDER",
    ["Vehicle Probability","Probability of dynamic patrol being a vehicle unit."],
    CATEGORY_DYNPAT,
    [
        0,
        1,
        0.25,
        2
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

nil