/*
Author: SENSEI

Last modified: 1/1/2015

Description: send PVEH to server to delete saved data

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define DELETE_HINT "Are you sure you want to permenantly delete ALL saved mission data?"
#define CONFIRMED_HINT "Data deleted from server."

if !(hasInterface) exitWith {};

[] spawn {
	closeDialog 0;
	_ret = [
		parseText (format ["<t align='center'>%1</t>",DELETE_HINT]),
		TITLE,
		"Yes",
		"No"
	] call bis_fnc_GUImessage;

	if (_ret) then {
		publicVariableServer DATA_DELETEPVEH;
		[CONFIRMED_HINT,true] call EFUNC(main,displayText);
	};
};