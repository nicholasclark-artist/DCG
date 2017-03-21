/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

PVEH_REQUEST addPublicVariableEventHandler {
	(_this select 1) call FUNC(handleRequest);
};

[
	{DOUBLES(PREFIX,main)},
	{
		[QUOTE(ADDON),QUOTE(COMPONENT_PRETTY),{},QUOTE(call FUNC(canCallTransport)),{call FUNC(getChildren)}] remoteExecCall [QEFUNC(main,setAction), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
