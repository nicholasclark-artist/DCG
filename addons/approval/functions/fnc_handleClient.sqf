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
    [QUOTE(ADDON),"Approval",{},QUOTE(true)],
    [HINT_ID,HINT_NAME,{HINT_STATEMENT},QUOTE(HINT_COND),{},[],player,1,ACTIONPATH]
];

if (CHECK_ADDON_1("ace_interact_menu")) then {
    _action = [QUESTION_ID, QUESTION_NAME, "", {QUESTION_STATEMENT_ACE}, {QUESTION_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
} else {
    [QUESTION_ID,QUESTION_NAME,{QUESTION_STATEMENT},QUOTE(QUESTION_COND),{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
};

[ADDON_TITLE, HINT_ID, HINT_NAME, {HINT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[ADDON_TITLE, QUESTION_ID, QUESTION_NAME, {QUESTION_KEYCODE}, ""] call CBA_fnc_addKeybind;
