/*
Author:
Nicholas Clark (SENSEI)

Description:
disables caching for group

Arguments:
0: group <GROUP>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_grp",grpNull,[grpNull]]
];

// stops entity from being added to cache system by addon
_grp setVariable [QGVAR(disable),true];

if (dynamicSimulationEnabled _grp) then {
    _grp enableDynamicSimulation false;
    TRACE_1("disable dynamic simulation",_grp);
};

nil
