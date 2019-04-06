/*
Author:
Nicholas Clark (SENSEI)

Description:
send groups to headless clients

Arguments:
0: object <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params ["_obj"];

if (isNull GVAR(HC) || {!(_obj in allUnits)} || {isPlayer _obj} || {_obj isKindOf "UAV"}) exitWith {};

private _id = owner GVAR(HC);

{
    if (!(_x getVariable [QGVAR(HCBlacklist), false]) && {!(owner _x isEqualTo _id)}) then {
        private _triggerWP = (waypoints _x) select {!((synchronizedTriggers _x) isEqualTo [])};

        if !(_triggerWP isEqualTo []) exitWith {};

        [_x,_id] call FUNC(setOwner);
    };
} forEach allGroups;

nil