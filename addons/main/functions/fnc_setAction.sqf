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
5: action arguments <ARRAY>
6: object to receive action <OBJECT>
7: ACE action type <NUMBER>
8: ACE action path <ARRAY>
9: ACE action position <ARRAY>
10: action activation distance <NUMBER>

Return:
array

VANILLA: [Action Index, Child Action Indices, EH Index]
ACE: [Action]
__________________________________________________________________*/
#include "script_component.hpp"
#define CODE_TO_STRING(CODE) (CODE select [1,(count CODE) - 2])

params [
    ["_id","",[""]],
    ["_name","",[""]],
    ["_statement",{},[{}]],
    ["_condition",{true},[{}]],
    ["_child",{},[{}]],
    ["_arguments",[],[[]]],
    ["_obj",player,[objNull]],
    ["_type",1,[0]],
    ["_path",["ACE_SelfActions",QGVARMAIN(actions)],[[]]],
    ["_pos",[0,0,0],[[]]],
    ["_distance",10,[0]]
];

private _actions = [];

// @todo test adding ace_common_fnc_canInteractWith check to ace condition
if (CHECK_ADDON_1(ace_interact_menu)) then {
    private _addAction = [_id,_name,"",_statement,_condition,_child,_arguments,_pos,_distance] call ace_interact_menu_fnc_createAction;
    _path = [_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
    _actions append _path;
} else {
    if (COMPARE_STR(_name,"")) exitWith {
        _actions = [-1,[-1],-1];
    };

    // convert condition code to string
    _condition = str _condition;
    _condition = CODE_TO_STRING(_condition);
    
    if !(_statement isEqualTo {}) then {
        // convert statement code to string and define action params
        _statement = str _statement;
        _statement = CODE_TO_STRING(_statement);
        _statement = ["params ['_target', '_caller', '_actionId', '_arguments'];",_statement] joinString "";

        private _addAction = _obj addAction [_name,_statement,_arguments,0,false,true,"",_condition,_distance];
        _actions pushBack _addAction;
    } else {
        _actions pushBack -1;
    };

    if !(_child isEqualTo {}) then {
        private _childActions = _arguments call _child;
        _actions pushBack _childActions;
    } else {
        _actions pushBack [-1];
    };

    private _event = -1;
    _statement = format [
        "
            if !(%2 isEqualTo {}) then {
                (_this select 0) addAction ['%1',%2,%3,0,false,true,'','%4'];
            };

            if !(%5 isEqualTo {}) then {
                %3 call %5;
            };
        ",_name,_statement,_arguments,_condition,_child
    ];

    if (local _obj) then {
        _event = _obj addEventHandler ["Respawn", _statement];
    } else {
        ["Respawn", _statement] remoteExecCall [QUOTE(addEventHandler), _obj, false];
        WARNING_1("Adding respawn eventhandler to %1 over network.",_obj);
    };

    _actions pushBack _event;
};

_actions