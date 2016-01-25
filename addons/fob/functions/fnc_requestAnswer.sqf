/*
Author:
Nicholas Clark (SENSEI)

Description:
answer request for FOB control

Arguments:
0: name of unit answering request <STRING>
1: answer type <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define KEY ((actionKeys "curatorInterface") select 0)
#define KEY_HINT [format ["%1 accepts your request. Press the Zeus key %3 to start constructing %2",(_this select 0),GVAR(name),keyName KEY],true] call EFUNC(main,displayText)
#define NOKEY_HINT [format ["%1 accepts your request. Press the Zeus key %3 to start constructing %2",(_this select 0),GVAR(name),'UNBOUND'],true] call EFUNC(main,displayText)

call {
	if ((_this select 1) isEqualTo 0) exitWith {
		[format ["%1 denies your request.", (_this select 0)],true] call EFUNC(main,displayText);
	};
	if ((_this select 1) isEqualTo 1) exitWith {
		if (!isNil {KEY}) then {
			KEY_HINT;
		} else {
			NOKEY_HINT;
		};
	};
	[format ["%1 did not answer your request.", (_this select 0)],true] call EFUNC(main,displayText);
};