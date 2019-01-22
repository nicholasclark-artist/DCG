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
    QGVAR(time),
    "SLIDER",
    ["Respawn Time","Time in seconds that the player must wait before respawn."],
    COMPONENT_NAME,
    [
        0,
        3600,
        600,
        0
    ],
    true,
    {
        INFO("LOCAL"); // @todo check locality 
        setPlayerRespawnTime _this;
    }
] call CBA_Settings_fnc_init;