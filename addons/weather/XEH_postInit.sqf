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
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);

		[_data] call FUNC(handleLoadData);

		setDate GVAR(date);
		GVAR(overcast) call BIS_fnc_setOvercast;
		/*[
			{
				GVAR(overcast) call BIS_fnc_setOvercast;
			},
			[],
			5
		] call CBA_fnc_waitAndExecute;*/
	}
] call CBA_fnc_waitUntilAndExecute;

ADDON = true;