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
    QGVAR(multiplier),
    "SLIDER",
    ["Enemy Count Multiplier",""],
    COMPONENT_NAME,
    [
        0.5,
        2,
        1,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(sniper),
    "CHECKBOX",
    ["Spawn Snipers","Spawn sniper units near occupied locations."],
    COMPONENT_NAME,
    true,
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(static),
    "CHECKBOX",
    ["Spawn Static Emplacements","Spawn static emplacements in occupied locations."],
    COMPONENT_NAME,
    true,
    true,
    {}
] call CBA_Settings_fnc_init;
