/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		{
			[QUOTE(ADDON),"Cancel Primary Task",QUOTE([1] call FUNC(cancel)),QUOTE(!(GVAR(primary) isEqualTo '') && {(isServer || serverCommandAvailable '#logout')}),"",player,1] call EFUNC(main,setAction);
			[QUOTE(ADDON),"Cancel Secondary Task",QUOTE([0] call FUNC(cancel)),QUOTE(!(GVAR(secondary) isEqualTo '') && {(isServer || serverCommandAvailable '#logout')}),"",player,1] call EFUNC(main,setAction);
		} remoteExecCall ["BIS_fnc_call",0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

[0,60] spawn FUNC(select);
[1,30] spawn FUNC(select);

ADDON = true;