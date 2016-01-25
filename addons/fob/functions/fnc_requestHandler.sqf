/*
Author: Nicholas Clark (SENSEI)

Last modified: 10/7/2015

Description: handles fob control requests

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

private "_userName";

_userName = "SERVER";

if (count _this isEqualTo 1) exitWith {
	[_this select 0] remoteExecCall [QFUNC(requestReceive), owner (getAssignedCuratorUnit GVAR(curator)), false];
};

if !(isNull (getAssignedCuratorUnit GVAR(curator))) then {
	_userName = name (getAssignedCuratorUnit GVAR(curator));
};

if ((_this select 1) isEqualTo 1) then {
	GVAR(UID) = "";
	(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QGVAR(UID);
	unassignCurator GVAR(curator);
	(_this select 0) assignCurator GVAR(curator);
	GVAR(UID) = getPlayerUID (_this select 0);
	(owner (_this select 0)) publicVariableClient QGVAR(UID);
	[(curatorEditableObjects GVAR(curator)),owner (_this select 0)] call EFUNC(main,setOwner); // need to set locality to new user, otherwise non local objects lag when edited
};

[_userName,_this select 1] remoteExec [QFUNC(requestAnswer), owner (_this select 0), false];