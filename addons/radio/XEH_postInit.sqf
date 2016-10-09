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
		// ACRE2 workaround, remove items from communications tab
		_data = missionnamespace getVariable "bis_fnc_arsenal_data";
		_data set [12,[]];
		missionnamespace setVariable ["bis_fnc_arsenal_data",_data,true];

		[[],{
			if (hasInterface) then {
				[
					{!isNull player && {alive player}},
					{
						call FUNC(checkLoadout);
						call FUNC(setRadioSettings);
					},
					[]
				] call CBA_fnc_waitUntilAndExecute;
			};
		}] remoteExecCall [QUOTE(BIS_fnc_call), 0, true];
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;