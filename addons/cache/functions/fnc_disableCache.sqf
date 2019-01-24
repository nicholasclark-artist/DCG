/*
Author:
Nicholas Clark (SENSEI)

Description:
disables caching for entity

Arguments:
0: entity <OBJECT,GROUP>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_entity",objNull,[grpNull,objNull]]
];

// stops entity from being added to cache system by addon
_entity setVariable [QGVAR(disable),true];

if (dynamicSimulationEnabled _entity) then {
    _entity enableDynamicSimulation false; // @todo for given non AI object??
};

nil
