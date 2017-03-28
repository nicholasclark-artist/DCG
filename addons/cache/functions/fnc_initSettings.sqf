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
    QGVAR(enable), // Internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX", // setting type
    format ["Enable %1", COMPONENT_NAME], // Pretty name shown inside the ingame settings menu. Can be stringtable entry.
    COMPONENT_NAME, // Pretty name of the category where the setting can be found. Can be stringtable entry.
    true, // data for this setting
    true, // "global" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
    {} // function that will be executed once on mission start and every time the setting is changed.
] call CBA_Settings_fnc_init;

[
    QGVAR(distCoef),
    "SLIDER",
    ["Activation Distance Multiplier","Multiplies the entity activation distance by set value if the entity is moving."],
    COMPONENT_NAME,
    [
        1,
        4,
        1.5,
        1
    ],
    true,
    {
        "IsMoving" setDynamicSimulationDistanceCoef GVAR(distCoef);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(distGroup),
    "SLIDER",
    ["Group Activation Distance",""],
    COMPONENT_NAME,
    [
        50,
        5000,
        1000,
        0
    ],
    true,
    {
        "Group" setDynamicSimulationDistance GVAR(distGroup);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(distVehicle),
    "SLIDER",
    ["Vehicle Activation Distance",""],
    COMPONENT_NAME,
    [
        50,
        5000,
        1000,
        0
    ],
    true,
    {
        "Vehicle" setDynamicSimulationDistance GVAR(distVehicle);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(distEmpty),
    "SLIDER",
    ["Empty Vehicle Activation Distance",""],
    COMPONENT_NAME,
    [
        50,
        5000,
        500,
        0
    ],
    true,
    {
        "EmptyVehicle" setDynamicSimulationDistance GVAR(distEmpty);
    }
] call CBA_Settings_fnc_init;

[
    QGVAR(distProp),
    "SLIDER",
    ["Prop Activation Distance",""],
    COMPONENT_NAME,
    [
        50,
        5000,
        250,
        0
    ],
    true,
    {
        "Prop" setDynamicSimulationDistance GVAR(distProp);
    }
] call CBA_Settings_fnc_init;
