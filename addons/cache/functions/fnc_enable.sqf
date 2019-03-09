/*
Author:
Nicholas Clark (SENSEI)

Description:
handle additions to dynamic simulation system

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_obj"];

if (!(_obj in allUnits) || {isPlayer _obj}) exitWith {};

{
    if (!(dynamicSimulationEnabled _x) && {!(isPlayer _x)} && {!(_x getVariable [QGVAR(disable),false])}) then {
        _x enableDynamicSimulation true;
        TRACE_1("enable dynamic simulation",_x);
    };
} forEach allGroups;

nil