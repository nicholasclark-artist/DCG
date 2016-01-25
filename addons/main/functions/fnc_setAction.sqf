/*
Author: Nicholas Clark (SENSEI)

Description:
set player action

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

if !(hasInterface) exitWith {};

private ["_action","_addAction","_childAction"];
params [
	["_id",""],
	["_name",""],
	["_statement",""],
	["_condition","true"],
	["_child",""],
	["_obj",player],
	["_type",1],
	["_path",["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]],
	["_pos",[0,0,0]],
	["_args",nil]
];

_action = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_addAction = [_id,_name,"",compile _statement,compile _condition,compile _child,[],_pos] call ace_interact_menu_fnc_createAction;
	[_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
	_action append _addAction;
} else {
	if !(_statement isEqualTo "") then {
		_addAction = _obj addAction [_name,compile _statement,_args,0,false,true,"",_condition];
		_action pushBack _addAction;
	};
	if !(_child isEqualTo "") then {
		_childAction = call compile _child;
		if (typeName _childAction isEqualTo "ARRAY") then {
			_action append _childAction;
		};
		if (typeName _childAction isEqualTo "SCALAR") then {
			_action pushBack _childAction;
		};
	};
};

_action