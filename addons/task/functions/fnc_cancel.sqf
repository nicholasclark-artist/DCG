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
#define CANCEL_HINT(TYPE) format ["Are you sure you want to cancel the current %1 task?",TYPE]

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
			GVAR(primary) = [];
			publicVariableServer QGVAR(primary);
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
			GVAR(secondary) = [];
			publicVariableServer QGVAR(secondary);
		};
	};
};