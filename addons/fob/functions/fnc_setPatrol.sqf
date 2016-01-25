/*
Author: SENSEI

Last modified: 12/23/2015

Description: set curator groups on patrol

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

{
	{
		if (_x isKindOf "Man" && {_x isEqualTo leader group _x}) then {
			[units group _x,GVAR(range),false] call EFUNC(main,setPatrol);
		};
	} forEach (curatorEditableObjects GVAR(curator));
} remoteExecCall ["BIS_fnc_call",2,false];