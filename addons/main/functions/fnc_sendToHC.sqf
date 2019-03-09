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
    if (!(units _x isEqualTo []) && {!(_x getVariable [QGVAR(HCBlacklist), false])}) then {
        private _triggerWP = (waypoints _x) select {!((synchronizedTriggers _x) isEqualTo [])};

        if !(_triggerWP isEqualTo []) exitWith {};

        if ((units _x) findIf {owner _x isEqualTo _id || {isPlayer _x} || {(vehicle _x) getVariable [QGVAR(HCBlacklist), false]}} > -1) exitWith {};

        [_x,_id] call FUNC(setOwner);
    };
} forEach allGroups;

nil