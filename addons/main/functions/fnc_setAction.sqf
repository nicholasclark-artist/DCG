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
#define CODE_TO_STRING(CODE) ((str CODE) select [1,(count (str CODE)) - 2])

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
    ["_distance",5,[0]]
];

private _actions = [];
private _addAction = -1;

// @todo test adding ace_common_fnc_canInteractWith check to ace condition
if (CHECK_ADDON_1(ace_interact_menu)) then {
    _addAction = [_id,_name,"",_statement,_condition,_child,_arguments,_pos,_distance] call ace_interact_menu_fnc_createAction;
    _path = [_obj, _type, _path, _addAction] call ace_interact_menu_fnc_addActionToObject;
    _actions append _path;
} else {
    private _childActions = [];

    if (COMPARE_STR(_name,"")) exitWith {
        _actions = [-1,[-1],-1];
    };

    // convert condition code to string
    _condition = CODE_TO_STRING(_condition);
    
    if !(_statement isEqualTo {}) then {
        // convert statement code to string and define action params
        _statement = CODE_TO_STRING(_statement);
        
        _statement = ["params [""_target"",""_caller"",""_actionId"",""_arguments""];",_statement] joinString "";
        
        _addAction = _obj addAction [_name,_statement,_arguments,0,false,true,"",_condition,_distance];
        _actions pushBack _addAction;
    } else {
        _statement = "";
        _actions pushBack -1;
    };

    if !(_child isEqualTo {}) then {
        _childActions = _arguments call _child;
        _actions pushBack _childActions;
    } else {
        _actions pushBack [-1];
    };
    
    private _event = -1;
    private _statement = format ["
        private _params = (_this select 1) actionParams %1;
        _params resize 10;

        if !((_params select 1) isEqualTo '') then {
            (_this select 0) addAction _params;
            (_this select 1) removeAction %1;
        };

        if !((%2 select 0) isEqualTo -1) then {
            {
                _params = (_this select 1) actionParams _x;
                _params resize 10;

                (_this select 0) addAction _params;
                (_this select 1) removeAction _x;
            } forEach %2;
        }; 
    ",_addAction,_childActions];

    if (local _obj) then {
        _event = _obj addEventHandler ["Respawn",_statement];
    } else {
        ["Respawn",_statement] remoteExecCall [QUOTE(addEventHandler),_obj,false];
        WARNING_1("adding respawn eventhandler to %1 over network.",_obj);
    };

    _actions pushBack _event;
};

_actions