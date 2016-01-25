/*
Author: SENSEI

Last modified: 11/3/2015

Description: delete fob

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

{
	deleteLocation GVAR(location);
} remoteExecCall ["BIS_fnc_call",0,true];
GVAR(UID) = "";
(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QGVAR(UID);
{_x call EFUNC(main,cleanup)} forEach (curatorEditableObjects GVAR(curator));
deleteVehicle GVAR(flag);
unassignCurator GVAR(curator);
GVAR(hq) = false;