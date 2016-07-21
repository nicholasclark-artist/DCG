/*
Author:
Nicholas Clark (SENSEI)

Description:
deploy FOB

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define KEY ((actionKeys "curatorInterface") select 0)
#define KEY_HINT [format ["Press %1 to construct %2.",keyName KEY,GVAR(name)],true] call EFUNC(main,displayText)
#define NOKEY_HINT [format ["Press %1 to construct %2.",'UNBOUND',GVAR(name)],true] call EFUNC(main,displayText)
#define ANIM toLower ("AinvPknlMstpSnonWnonDnon_medic4")
#define ANIM_TIME 8

if ((getPosASL player isFlatEmpty [4, -1, 0.3, 15, 0, false, player]) isEqualTo []) exitWith {
	[format ["Unsuitable position for %1. Select a flat, open area.",GVAR(name)],true] call EFUNC(main,displayText);
};

[player,ANIM] call EFUNC(main,setAnim);

[{
	missionNamespace setVariable [PVEH_DEPLOY,[player,getPosATL player,1]];
	publicVariableServer PVEH_DEPLOY;
	if (!isNil {KEY}) then {
		KEY_HINT;
	} else {
		NOKEY_HINT;
	};
}, [], ANIM_TIME] call CBA_fnc_waitAndExecute;