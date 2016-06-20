/*
Author:
Nicholas Clark (SENSEI)

Description:
set action

Arguments:
0: action id <STRING>
1: action display name <STRING>
2: code to run on action use <STRING>
3: action condition <STRING>
3: child action <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_actions","_addAction","_EHStr","_EH","_childAction"];
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
	["_params",[]],
	["_args",[]]
];

/*
	VANILLA: [Action Index, EH Index, Child Action Indexes, Child EH Index]
	ACE: [Action]
*/
_actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_addAction = [_id,_name,"",compile _statement,compile _condition,compile _child,_params,_pos] call ace_interact_menu_fnc_createAction;
	[_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
	_actions append _addAction;
} else {
	if !(_statement isEqualTo "") then {
		_addAction = _obj addAction [_name,compile _statement,_args,0,false,true,"",_condition];
		_actions pushBack _addAction;
		_EHStr = format ["player addAction [%1,compile %2,%3,0,false,true,'',%4];",str _name,str _statement,_args,str _condition];
		_EH = player addEventHandler ["Respawn", _EHStr];
		_actions pushBack _EH;
	} else {
		_actions append [-1,-1];
	};

	if !(_child isEqualTo "") then {
		_childAction = call compile _child;
		_actions pushBack _childAction;

		_EHStr = format ["call compile %1;", str _child];
		_EH = player addEventHandler ["Respawn", _EHStr];
		_actions pushBack _EH;
	} else {
		_actions append [[-1],-1];
	};
};

_actions