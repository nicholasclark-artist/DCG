/*
Author: SENSEI

Last modified: 1/23/2016

Description: deploy FOB

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define KEY ((actionKeys "curatorInterface") select 0)
#define KEY_HINT [format ["Press the Zeus key, %1, to start %2 construction.",keyName KEY,GVAR(name)],true] call EFUNC(main,displayText)
#define NOKEY_HINT [format ["Press the Zeus key, %1, to start %2 construction.",'UNBOUND',GVAR(name)],true] call EFUNC(main,displayText)

if ((getPosATL player isFlatEmpty [3, 0, 0.4, 15, 0, false, player]) isEqualTo []) exitWith {
	[format ["Unsuitable position for %1. Select a flat open area.",GVAR(name)],true] call EFUNC(main,displayText);
};

[] spawn {
	[format ["Deploying %1...", GVAR(name)],true] call EFUNC(main,displayText);
	sleep 3;
	missionNamespace setVariable [PVEH_DEPLOY,[player,1]];
	publicVariableServer PVEH_DEPLOY;
	if (!isNil {KEY}) then {
		KEY_HINT;
	} else {
		NOKEY_HINT;
	};
};
