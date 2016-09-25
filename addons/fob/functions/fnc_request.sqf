/*
Author:
Nicholas Clark (SENSEI)

Description:
sends request for FOB control

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (isNull (getAssignedCuratorUnit GVAR(curator))) exitWith {
	missionNamespace setVariable [PVEH_REQUEST,[player,1]];
	publicVariableServer PVEH_REQUEST;
};

GVAR(requestReady) = 0;
missionNamespace setVariable [PVEH_REQUEST,[player]];
publicVariableServer PVEH_REQUEST;