/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/22/2015

Description: receive request for FOB control

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define FORMAT_SETUP \
	GVAR(response), \
	GVAR(ID1), \
	GVAR(ID2), \
	QEFUNC(main,removeAction), \
	missionNamespace setVariable [PVEH_REQUEST,[player,GVAR(response)]], \
	publicVariableServer str PVEH_REQUEST

GVAR(response) = -1;
GVAR(ID1) = -1;
GVAR(ID2) = -1;

[format ["%1 requests control of %2.",name (_this select 0),GVAR(name)],true] call EFUNC(main,displayText);

GVAR(ID1) = [format ["%1_requestAccept",QUOTE(ADDON)],"Accept Request",format [
	"
		%1 = 1;
		[player,1,%2] call %4;
		[player,1,%3] call %4;
		%5;
		%6;
	",
	FORMAT_SETUP
],"true","",player,1,ACTIONPATH] call EFUNC(main,setAction);

GVAR(ID2) = [format ["%1_requestAccept",QUOTE(ADDON)],"Accept Request",format [
	"
		%1 = 0;
		[player,1,%2] call %4;
		[player,1,%3] call %4;
		%5;
		%6;
	",
	FORMAT_SETUP
],"true","",player,1,ACTIONPATH] call EFUNC(main,setAction);

[{
	params ["_args","_idPFH"];
	_args params ["_time"];

	if !(GVAR(response) isEqualTo -1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
	};
	if (diag_tickTime > _time) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		if (GVAR(response) isEqualTo -1) then {
			[player,1,GVAR(ID1)] call EFUNC(main,removeAction);
			[player,1,GVAR(ID2)] call EFUNC(main,removeAction);
			missionNamespace setVariable [PVEH_REQUEST,[player,GVAR(response)]];
			publicVariableServer PVEH_REQUEST;
		};
	};
}, 1, [diag_tickTime + 60]] call CBA_fnc_addPerFrameHandler;