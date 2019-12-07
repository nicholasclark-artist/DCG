/*
Author:
Nicholas Clark (SENSEI)

Description:
initialize settings via CBA framework

Arguments:

Return:
nil
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

nil