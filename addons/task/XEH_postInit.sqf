/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[
	{DOUBLES(PREFIX,main)},
	{
		// load data
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);

		[_data] call FUNC(handleLoadData);

		[[],{
			if (hasInterface) then {
				[
					{!isNull player && {alive player}},
					{
						{
							_x call EFUNC(main,setAction);
						} forEach [
							[QUOTE(ADDON),"Tasks","","true",""],
							[QUOTE(DOUBLES(ADDON,primary)),"Cancel Primary Task",QUOTE([1] call FUNC(cancel)),QUOTE(isServer || serverCommandAvailable '#logout'),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]],
							[QUOTE(DOUBLES(ADDON,secondary)),"Cancel Secondary Task",QUOTE([0] call FUNC(cancel)),QUOTE(isServer || serverCommandAvailable '#logout'),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]]
						];
					}
				] call CBA_fnc_waitUntilAndExecute;
			};
		}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;