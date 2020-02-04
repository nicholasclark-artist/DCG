/*
Author:
Nicholas Clark (SENSEI)

Description:
handle additions to dynamic simulation system

Arguments:
0: object <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_obj"];

if (!isNull (group _obj) && {!(dynamicSimulationEnabled (group _obj))} && {!((group _obj) getVariable [QGVAR(disableGroup),false])}) then {
    [QGVAR(enableGroup),group _obj] call CBA_fnc_localEvent;
};

nil