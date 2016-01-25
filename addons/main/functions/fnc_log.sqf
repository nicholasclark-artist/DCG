/*
Author: SENSEI

Last modified: 11/1/2015

Description: logs message to RPT

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define PREFIX_DEBUG toUpper (_this select 0)
#define MESSAGE format (_this select 1)

diag_log text format ["[%1] %2",PREFIX_DEBUG,MESSAGE];

if (CHECK_DEBUG) then {
	if (isDedicated) then {
		([format ["[%1] %2",PREFIX_DEBUG,MESSAGE],false]) remoteExecCall [QEFUNC(main,displayText),-2,false];
	} else {
		[format ["[%1] %2",PREFIX_DEBUG,MESSAGE],false] call EFUNC(main,displayText);
	};
};