/*
Author: Nicholas Clark (SENSEI)

Last modified: 8/8/2015

Description: sends request for FOB control

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (player isEqualTo (getAssignedCuratorUnit GVAR(curator))) exitWith {
	[format ["You already control %1.",GVAR(name)],true] call EFUNC(main,displayText);
};

if (isNull (getAssignedCuratorUnit GVAR(curator))) exitWith {
	missionNamespace setVariable [PVEH_REQUEST,[player,1]];
	publicVariableServer PVEH_REQUEST;
};

missionNamespace setVariable [PVEH_REQUEST,[player]];
publicVariableServer PVEH_REQUEST;