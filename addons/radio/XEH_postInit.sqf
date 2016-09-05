/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		// ACRE2 workaround, remove items from communications tab
		_data = missionnamespace getVariable "bis_fnc_arsenal_data";
		_data set [12,[]];
		missionnamespace setVariable ["bis_fnc_arsenal_data",_data,true];

		[
			{!isNull player && {alive player}},
			{
				call FUNC(checkLoadout);
				call FUNC(setRadioSettings);
			},
			[]
		] remoteExecCall [QUOTE(CBA_fnc_waitUntilAndExecute), 0, true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;