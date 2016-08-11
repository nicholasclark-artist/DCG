/*
Author:
Nicholas Clark (SENSEI)

Description:

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if (player isEqualTo (getAssignedCuratorUnit GVAR(curator))) then {
	if (isNull (findDisplay 312)) then {
		openCuratorInterface;
	} else {
		findDisplay 312 closeDisplay 2;
	};
};