/*
Author:
Nicholas Clark (SENSEI)

Description:
set action

Arguments:
0: action id <STRING>
1: action display name <STRING>
2: action statement <STRING>
3: action condition <STRING>
4: child action <STRING>
5: object to add action to <OBJECT>
6: ACE action type <NUMBER>
7: ACE action path <ARRAY>
8: ACE action position <ARRAY>
9: action parameters <ARRAY>

Return:
array

VANILLA: [Action Index, Child Action Indices, EH Index]
ACE: [Action]
__________________________________________________________________*/
#include "script_component.hpp"

private ["_actions","_addAction","_EHStr","_EH","_childActions"];
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
	["_params",[]]
];

if !(local _obj) exitWith {
	WARNING_1("Cannot set action, %1 is not local.",_obj);
};

_actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_addAction = [_id,_name,"",compile _statement,compile _condition,compile _child,_params,_pos] call ace_interact_menu_fnc_createAction;
	[_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
	_path pushBack _id;
	_actions append _path;
} else {
	if (_name isEqualTo "") exitWith {
		_actions = [-1,[-1],-1];
	};

	if !(_statement isEqualTo "") then {
		_addAction = _obj addAction [_name,compile _statement,_params,0,false,true,"",_condition];
		_actions pushBack _addAction;
	} else {
		_actions pushBack -1;
	};

	if !(_child isEqualTo "") then {
		_childActions = call compile _child;
		_actions pushBack _childActions;
	} else {
		_actions pushBack [-1];
	};

	_EHStr = format [
		"
			if !(%2 isEqualTo '') then {
				(_this select 0) addAction [%1,compile %2,%3,0,false,true,'',%4];
			};

			if !(%5 isEqualTo '') then {
				call compile %5;
			};
		",str _name,str _statement,_params,str _condition,str _child
	];

	_EH = _obj addEventHandler ["Respawn", _EHStr];

	_actions pushBack _EH;
};

_actions