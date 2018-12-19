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
	{MAIN_ADDON},
	{
        [[],{
        	if (hasInterface) then {
                call FUNC(handleClient);
        	};
        }] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

// ADDON = true;
