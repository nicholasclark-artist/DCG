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
#define CATEGORY_HOSTILE [COMPONENT_NAME,"Hostile Entity Settings"]

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
    ["Approval Multiplier","Multiplier for the rate of approval change."],
    COMPONENT_NAME,
    [
        0.1,
        2,
        1,
        1
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(hostileHint),
    "CHECKBOX",
    ["Enable Hostile Notification","Notify players when hostile entities spawn."],
    CATEGORY_HOSTILE,
    true,
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(hostileCooldown),
    "SLIDER",
    ["Hostile Spawn Cooldown","Time in seconds between possible hostile entity spawns."],
    CATEGORY_HOSTILE,
    [
        300,
        3600,
        900,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
