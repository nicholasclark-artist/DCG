/*
Author:
Nicholas Clark (SENSEI)

Description:
delete FOB on server

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _unit = getAssignedCuratorUnit GVAR(curator);

{
    // remove approval bonus, ignore units in vehicles, only subtract cost of vehicle
    if (CHECK_ADDON_2(approval) && {!(_x isKindOf "Man") || (_x isKindOf "Man" && (isNull objectParent _x))}) then {
        _cost = [typeOf _x] call FUNC(getCuratorCost);
        _cost = _cost*FOB_COST_MULTIPIER;
        [QEGVAR(approval,add),[FOB_POSITION,_cost*-1]] call CBA_fnc_serverEvent;
    };
    [QEGVAR(main,cleanup),_x] call CBA_fnc_serverEvent;
} forEach (curatorEditableObjects GVAR(curator));

// remove approval bonus
[QEGVAR(approval,add),[FOB_POSITION,AP_FOB*-1]] call CBA_fnc_serverEvent;

// remove objects from editable array so objects are not part of new FOB if placed in same position
GVAR(curator) removeCuratorEditableObjects [curatorEditableObjects GVAR(curator),true];

GVAR(respawnPos) call BIS_fnc_removeRespawnPosition;
[false] call FUNC(setRecon);

{deleteVehicle _x} forEach (GVAR(anchor) getVariable [QGVAR(composition),[]]);
deleteVehicle GVAR(anchor);
{deleteLocation GVAR(location)} remoteExecCall [QUOTE(BIS_fnc_call),0,false];

// reassign previous curator
if !(isNull GVAR(curatorExternal)) then {
    [GVAR(curatorExternal),_unit] call FUNC(handleAssign);

    // reset external curator var after reassign
    [
        {getAssignedCuratorUnit GVAR(curatorExternal) isEqualTo (_this select 0)},
        {
            GVAR(curatorExternal) = objNull;
        },
        [_unit]
    ] call CBA_fnc_waitUntilAndExecute;
} else {
    [objNull,_unit] call FUNC(handleAssign);
}
