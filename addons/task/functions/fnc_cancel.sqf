/*
Author:
Nicholas Clark (SENSEI)

Description:
cancel current task

Arguments:
0: task type <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define CANCEL_HINT(TASKTYPE) format ["Are you sure you want to cancel the current %1 task?",TASKTYPE]
#define CONFIRMED_HINT "Task canceled."

if !(hasInterface) exitWith {};

// primary task
if ((_this select 0) > 0) then {
	[] spawn {
		closeDialog 0;
		_ret = [
			parseText (format ["<t align='center'>%1</t>",CANCEL_HINT("primary")]),
			TITLE,
			"Yes",
			"No"
		] call bis_fnc_GUImessage;

		if (_ret) then {
			GVAR(primary) = "";
			publicVariable QGVAR(primary);
			[CONFIRMED_HINT,true] call EFUNC(main,displayText);
		};
	};
} else {
	// secondary task
	[] spawn {
		closeDialog 0;
		_ret = [
			parseText (format ["<t align='center'>%1</t>",CANCEL_HINT("secondary")]),
			TITLE,
			"Yes",
			"No"
		] call bis_fnc_GUImessage;

		if (_ret) then {
			GVAR(secondary) = "";
			publicVariable QGVAR(secondary);
			[CONFIRMED_HINT,true] call EFUNC(main,displayText);
		};
	};
};