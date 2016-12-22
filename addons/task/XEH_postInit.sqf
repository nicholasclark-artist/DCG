/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main) && {CHECK_POSTBRIEFING}},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
                {
                    _x call EFUNC(main,setAction);
                } forEach [
                    [QUOTE(ADDON),"Tasks",{}],
                    [QUOTE(DOUBLES(ADDON,primary)),"Cancel Primary Task",{PRIM_STATEMENT},QUOTE(PRIM_COND),{},[],player,1,ACTIONPATH],
                    [QUOTE(DOUBLES(ADDON,secondary)),"Cancel Secondary Task",{SEC_STATEMENT},QUOTE(SEC_COND),{},[],player,1,ACTIONPATH]
                ];
			};
		}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
