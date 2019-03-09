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
    QGVAR(cargoThreshold),
    "SLIDER",
    ["Minimum Cargo Positions","Minimum number of available cargo positions in transport."],
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
    QGVAR(limit),
    "SLIDER",
    ["Transport Limit","Maximum number of active transports."],
    COMPONENT_NAME,
    [
        1,
        5,
        3,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(cooldown),
    "SLIDER",
    ["Transport Cooldown","Time in seconds until a player can request another transport."],
    COMPONENT_NAME,
    [
        1,
        3600,
        300,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
