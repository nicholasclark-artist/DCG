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
        if (!isServer) exitWith {};
        "IsMoving" setDynamicSimulationDistanceCoef _this;
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
        if (!isServer) exitWith {};
        "Group" setDynamicSimulationDistance _this;
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
        if (!isServer) exitWith {};
        "Vehicle" setDynamicSimulationDistance _this;
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
        if (!isServer) exitWith {};
        "EmptyVehicle" setDynamicSimulationDistance _this;
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
        if (!isServer) exitWith {};
        "Prop" setDynamicSimulationDistance _this;
    }
] call CBA_Settings_fnc_init;
