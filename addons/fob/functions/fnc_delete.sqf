/*
Author:
Nicholas Clark (SENSEI)

Description:
delete fob

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

if ({typeOf _x in FOB_HQ} count (curatorEditableObjects GVAR(curator)) > 0) then {
	[QGVAR(removeRecon), [], getAssignedCuratorUnit GVAR(curator)] call CBA_fnc_targetEvent;
};

{_x call EFUNC(main,cleanup)} forEach (curatorEditableObjects GVAR(curator));

GVAR(UID) = "";
(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QGVAR(UID);
[QEGVAR(main,deleteLocation), [GVAR(location)]] call CBA_fnc_globalEvent;
remoteExecCall ["", CREATELOC_JIPID];

deleteVehicle GVAR(anchor);
unassignCurator GVAR(curator);