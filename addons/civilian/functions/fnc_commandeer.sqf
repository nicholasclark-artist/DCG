/*
Author:
Nicholas Clark (SENSEI)

Description:
take control of civilian vehicle

Arguments:
0: vehicle to commandeer <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params ["_veh"];

private _driver = driver _veh;

_veh setVariable [QGVAR(commandeer),true,true];

{
    unassignVehicle _x;
    _x leaveVehicle _veh;
} forEach (crew _veh);

GVAR(drivers) deleteAt (GVAR(drivers) find _driver);
[QEGVAR(main,cleanup),_driver] call CBA_fnc_serverEvent;

nil