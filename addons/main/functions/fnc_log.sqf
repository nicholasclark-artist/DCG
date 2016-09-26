/*
Author:
Nicholas Clark (SENSEI)

Description:
logs debug message

Arguments:
0: message prefix <STRING>
1: message <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define PREFIX_DEBUG toUpper (_this select 0)
#define MESSAGE format (_this select 1)
#define MESSAGE_FORMAT format ["[%1] %2",PREFIX_DEBUG,MESSAGE]

diag_log text MESSAGE_FORMAT;

if (CHECK_DEBUG) then {
	([MESSAGE_FORMAT,false]) remoteExecCall [QEFUNC(main,displayText),0,false];
};