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
    QGVAR(coef),
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
