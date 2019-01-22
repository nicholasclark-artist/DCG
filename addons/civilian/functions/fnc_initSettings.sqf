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
    {[QGVAR(enable),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(spawnDist),
    "SLIDER",
    ["Spawn Distance","Civilian entities will spawn when a player is within this distance of a location."],
    COMPONENT_NAME,
    [
        1,
        1000,
        300,
        0
    ],
    true,
    {[QGVAR(spawnDist),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(unitLimit),
    "SLIDER",
    ["Unit Limit","Limits the number of civilian units per location."],
    COMPONENT_NAME,
    [
        0,
        40,
        30,
        0
    ],
    true,
    {[QGVAR(unitLimit),_this] call EFUNC(main,handleSettingChange)},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(vehLimit),
    "SLIDER",
    ["Vehicle Limit","Limits the number of spawned civilian vehicles."],
    COMPONENT_NAME,
    [
        0,
        10,
        5,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;

[
    QGVAR(vehCooldown),
    "SLIDER",
    ["Vehicle Cooldown","Time in seconds between potential vehicle spawns."],
    COMPONENT_NAME,
    [
        60,
        3600,
        300,
        0
    ],
    true,
    {}
] call CBA_Settings_fnc_init;
