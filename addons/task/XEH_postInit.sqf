/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

CHECK_POSTINIT;

[
	{DOUBLES(PREFIX,main)},
	{
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
                {
                    _x call EFUNC(main,setAction);
                } forEach [
                    [QUOTE(ADDON),QUOTE(COMPONENT_PRETTY),{}],
                    [QUOTE(DOUBLES(ADDON,primary)),"Cancel Primary Task",{PRIM_STATEMENT},{PRIM_COND},{},[],player,1,ACTIONPATH],
                    [QUOTE(DOUBLES(ADDON,secondary)),"Cancel Secondary Task",{SEC_STATEMENT},{SEC_COND},{},[],player,1,ACTIONPATH]
                ];
			};
		}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;
