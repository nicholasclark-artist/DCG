/*
Author:
Nicholas Clark (SENSEI)

Description:
remove player action

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_actionIndex","_actionEH","_childIndex"];
params [
	["_obj",player],
	["_type",1],
	"_action"
];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	[_obj,_type,_action] call ace_interact_menu_fnc_removeActionFromObject;
} else {
	_actionIndex = _action select 0;
	_childIndex = _action select 1;
	_actionEH = _action select 2;

	_obj removeAction _actionIndex;
	{
		_obj removeAction _x;
	} forEach _childIndex;

	_obj removeEventHandler ["Respawn", _actionEH];
};