/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define TASK_TITLE(LOC) format ["Liberate %1", LOC]
#define TASK_DESC(LOC) format ["Enemy forces have occupied %1! Liberate the settlement!",LOC]

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			[_data select 0] call FUNC(findLocation);
		} else { // if previous data was saved without occupy addon
			[] call FUNC(findLocation);
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;