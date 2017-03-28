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

params [
    ["_entity",objNull,[grpNull,objNull]]
];

if !(isServer) exitWith {};

// stops entity from being added to cache system by addon
_entity setVariable [CACHE_DISABLE,true];

if (dynamicSimulationEnabled _entity) then {
    _entity enableDynamicSimulation false;
};

nil
