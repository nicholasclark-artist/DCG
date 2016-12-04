/*
Author:
Nicholas Clark (SENSEI)

Description:
delete FOB on server

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private _unit = getAssignedCuratorUnit GVAR(curator);

{
    // ignore units in vehicles, only subtract cost of vehicle
    if (EGVAR(approval,enable) isEqualTo 1 && {!(_x isKindOf "Man") || (_x isKindOf "Man" && (isNull objectParent _x))}) then {
        _cost = [typeOf _x] call FUNC(getCuratorCost);
        _cost = _cost*COST_MULTIPIER;
        [FOB_POSITION,_cost*-1] call EFUNC(approval,addValue);
    };
    _x call EFUNC(main,cleanup);
    false
} count (curatorEditableObjects GVAR(curator));

// remove objects from editable array so objects are not part of new FOB if placed in same position
GVAR(curator) removeCuratorEditableObjects [curatorEditableObjects GVAR(curator),true];

[FOB_POSITION,AV_FOB*-1] call EFUNC(approval,addValue);
[false] call FUNC(handleRecon);
deleteVehicle GVAR(anchor);
unassignCurator GVAR(curator);

// reassign previous curator
if !(isNull GVAR(curatorExternal)) then {
    [
        {
            (_this select 0) assignCurator GVAR(curatorExternal);
            GVAR(curatorExternal) = objNull;
        },
        [_unit],
        2
    ] call CBA_fnc_waitAndExecute;
};

GVAR(respawnPos) call BIS_fnc_removeRespawnPosition;

{
    deleteLocation GVAR(location);
} remoteExecCall [QUOTE(BIS_fnc_call), 0, false];
