/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{MAIN_ADDON},
	{
		{
			GVAR(blacklist) pushBack [getpos _x, (triggerArea _x) select 0];
		} forEach EGVAR(safezone,list);

		if (!isNil {HEADLESSCLIENT} && {!(CHECK_ADDON_1("acex_headless"))}) then { // let ace handle transfer if enabled
			(owner HEADLESSCLIENT) publicVariableClient QFUNC(handlePatrol);
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(blacklist);

			[FUNC(handlePatrol), GVAR(cooldown), []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler), owner HEADLESSCLIENT, false];
		} else {
			[FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
		};
	}
] call CBA_fnc_waitUntilAndExecute;

// ADDON = true;
