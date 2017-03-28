/*
Author:
Nicholas Clark (SENSEI)

Description:
handle client setup

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

{
    _x call EFUNC(main,setAction);
} forEach [
    [QUOTE(ADDON),QUOTE(COMPONENT_PRETTY),{},{true}],
    [HINT_ID,HINT_NAME,{HINT_STATEMENT},{HINT_COND},{},[],player,1,ACTIONPATH]
];

if (CHECK_ADDON_1("ace_interact_menu")) then {
    private _action = [HALT_ID, HALT_NAME, "", {HALT_STATEMENT_ACE}, {HALT_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
    private _action = [QUESTION_ID, QUESTION_NAME, "", {QUESTION_STATEMENT_ACE}, {QUESTION_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
} else {
    [HALT_ID,HALT_NAME,{HALT_STATEMENT},{HALT_COND},{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
    [QUESTION_ID,QUESTION_NAME,{QUESTION_STATEMENT},{QUESTION_COND},{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
};

[COMPONENT_NAME, HINT_ID, HINT_NAME, {HINT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, HALT_ID, HALT_NAME, {HALT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QUESTION_ID, QUESTION_NAME, {QUESTION_KEYCODE}, ""] call CBA_fnc_addKeybind;
