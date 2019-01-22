/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

POSTINIT;

// @todo add support for rectangular blacklists 
{
    GVAR(blacklist) pushBack [getpos _x, (triggerArea _x) select 0];
} forEach EGVAR(main,safezoneTriggers);

if (!isNil {HEADLESSCLIENT} && {!(CHECK_ADDON_1(acex_headless))}) then { // let ace handle transfer if enabled
    (owner HEADLESSCLIENT) publicVariableClient QFUNC(handlePatrol);
    (owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);
    (owner HEADLESSCLIENT) publicVariableClient QGVAR(blacklist);

    [FUNC(handlePatrol), GVAR(cooldown), []] remoteExecCall [QUOTE(CBA_fnc_addPerFrameHandler), owner HEADLESSCLIENT, false];
} else {
    [FUNC(handlePatrol), GVAR(cooldown), []] call CBA_fnc_addPerFrameHandler;
};