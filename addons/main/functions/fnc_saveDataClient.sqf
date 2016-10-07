/*
Author:
Nicholas Clark (SENSEI)

Description:
send PVEH to server to save data

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define SAVE_HINT format ["Are you sure you want to overwrite the saved data for %1?", DATA_MISSION_ID]
#define CONFIRMED_HINT "Data saved."

if !(hasInterface) exitWith {};

[] spawn {
	closeDialog 0;
	_ret = [
		parseText (format ["<t align='center'>%1</t>",SAVE_HINT]),
		TITLE,
		"Yes",
		"No"
	] call bis_fnc_GUImessage;

	if (_ret) then {
		publicVariableServer DATA_SAVEPVEH;
		[CONFIRMED_HINT,true] call EFUNC(main,displayText);
	};
};