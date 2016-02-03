/*
Author:
Nicholas Clark (SENSEI)

Description:
handles fob control requests

Arguments:
0: unit that initiated request <OBJECT>
1: request answer <NUMBER>

Return:
none
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

if ((_this select 1) isEqualTo 1) then { // if current curator unit accepts request
	GVAR(UID) = "";
	(owner (getAssignedCuratorUnit GVAR(curator))) publicVariableClient QGVAR(UID); // reset UID on current curator unit
	unassignCurator GVAR(curator);
	(_this select 0) assignCurator GVAR(curator);
	GVAR(UID) = getPlayerUID (_this select 0);
	(owner (_this select 0)) publicVariableClient QGVAR(UID); // send new curator unit UID
	remoteExecCall [QFUNC(curatorEH), owner (_this select 0), false]; // run curator EH on new unit
	[(curatorEditableObjects GVAR(curator)),owner (_this select 0)] call EFUNC(main,setOwner); // set object locality to new unit, otherwise non local objects lag when edited
};

[_userName,_this select 1] remoteExec [QFUNC(requestAnswer), owner (_this select 0), false]; // send answer to new unit