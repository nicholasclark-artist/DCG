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
    format ["Enable %1",COMPONENT_NAME],
    COMPONENT_NAME,
    true,
    true,
    {},
    true
] call CBA_Settings_fnc_init;

[
    QGVAR(density),
    "SLIDER",
    ["IED density","Determines how many roadside IEDs are spread throughout the map."],
    COMPONENT_NAME,
    [
        0,
        1,
        0.5,
        1
    ],
    true,
    {},
    true
] call CBA_Settings_fnc_init;