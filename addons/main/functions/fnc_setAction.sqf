/*
Author:
Nicholas Clark (SENSEI)

Description:
set action

Arguments:
0: action id <STRING>
1: action display name <STRING>
2: action statement <CODE>
3: action condition <STRING>
4: child action <CODE>
5: action parameters <ARRAY>
6: object to add action to <OBJECT>
7: ACE action type <NUMBER>
8: ACE action path <ARRAY>
9: ACE action position <ARRAY>

Return:
array

VANILLA: [Action Index, Child Action Indices, EH Index]
ACE: [Action]
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_id","",[""]],
	["_name","",[""]],
	["_statement",{},[{}]],
	["_condition",{true},[{}]],
	["_child",{},[{}]],
    ["_params",[],[[]]],
	["_obj",player,[objNull]],
	["_type",1,[0]],
	["_path",["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))],[[]]],
	["_pos",[0,0,0],[[]]]
];

private _actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	private _addAction = [_id,_name,"",_statement,_condition,_child,_params,_pos] call ace_interact_menu_fnc_createAction;
	_path = [_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
	_actions append _path;
} else {
	if (_name isEqualTo "") exitWith {
		_actions = [-1,[-1],-1];
	};

    // convert cond code to string
    _condition = str _condition;
    _condition = _condition select [1,(count _condition) - 2];

	if !(_statement isEqualTo {}) then {
		private _addAction = _obj addAction [_name,_statement,_params,0,false,true,"",_condition];
		_actions pushBack _addAction;
	} else {
		_actions pushBack -1;
	};

	if !(_child isEqualTo {}) then {
		private _childActions = _params call _child;
		_actions pushBack _childActions;
	} else {
		_actions pushBack [-1];
	};

    private _EH = -1;
	private _EHStr = format [
		"
			if !(%2 isEqualTo {}) then {
				(_this select 0) addAction ['%1',%2,%3,0,false,true,'','%4'];
			};

			if !(%5 isEqualTo {}) then {
				%3 call %5;
			};
		",_name,_statement,_params,_condition,_child
	];

    if (local _obj) then {
        _EH = _obj addEventHandler ["Respawn", _EHStr];
    } else {
        [_obj, "Respawn", _EHStr] remoteExecCall [QUOTE(addEventHandler), _obj, false];
        WARNING_1("Adding respawn eventhandler to %1 over network.",_obj);
    };

	_actions pushBack _EH;
};

_actions
