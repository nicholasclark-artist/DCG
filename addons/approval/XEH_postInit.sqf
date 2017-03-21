/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

PVEH_QUESTION addPublicVariableEventHandler {(_this select 1) call FUNC(handleQuestion)};
PVEH_HINT addPublicVariableEventHandler {[_this select 1,0] call FUNC(handleHint)};
PVEH_HALT addPublicVariableEventHandler {[_this select 1] spawn FUNC(handleHalt)};
PVEH_AVADD addPublicVariableEventHandler {
    (_this select 1) call FUNC(addValue);
    LOG_1("Client add AV: %1",_this);
};

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[{
			[FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;
		}, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

		[[],{
			if (hasInterface) then {
                call FUNC(handleClient);
			};
 		}] remoteExecCall [QUOTE(BIS_fnc_call),0,true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
