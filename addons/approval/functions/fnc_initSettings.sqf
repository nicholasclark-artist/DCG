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
    {[QGVAR(enable),_this] call EFUNC(main,handleSettingChange)},
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
    QGVAR(regionSize),
    "SLIDER",
    ["Region Size",format ["Approximate diameter of each region cell in meters. If the value is greater than or equal to the current world size (%1: %2), a single region will cover the entire map.",worldName,worldSize]],
    COMPONENT_NAME,
    [
        1000,
        10000,
        6000,
        0
    ],
    true,
    {[QGVAR(regionSize),_this] call EFUNC(main,handleSettingChange)},
    true
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
