/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_INIT;

CHECK_ADDON;

PVEH_REQUEST addPublicVariableEventHandler {
	(_this select 1) call FUNC(handleRequest);
};

[
	{DOUBLES(PREFIX,main)},
	{
		[QUOTE(ADDON),"Transport",{},QUOTE(call FUNC(canCallTransport)),{call FUNC(getChildren)}] remoteExecCall [QEFUNC(main,setAction), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
