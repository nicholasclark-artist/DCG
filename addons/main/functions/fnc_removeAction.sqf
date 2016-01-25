/*
Author: Nicholas Clark (SENSEI)

Last modified: 11/16/2014

Description: remove player action

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

params [
	["_obj",player],
	["_type",1],
	"_action"
];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	[_obj,_type,_action] call ace_interact_menu_fnc_removeActionFromObject;
} else {
	if (typeName _action isEqualTo "ARRAY") then {
		{
			_obj removeAction _x;
		} forEach _action;
	};
	if (typeName _action isEqualTo "SCALAR") then {
		_obj removeAction _action;
	};
};