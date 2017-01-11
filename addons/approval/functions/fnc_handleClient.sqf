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
    private _action = [QUESTION_ID, QUESTION_NAME, "", {QUESTION_STATEMENT_ACE}, {QUESTION_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;

    private _action = [MARK_ID,MARK_NAME,"",{MARK_STATEMENT_ACE},{MARK_COND_ACE},{},[]] call ace_interact_menu_fnc_createAction;
	[player, 1, ACTIONPATH, _action] call ace_interact_menu_fnc_addActionToObject;
} else {
    [QUESTION_ID,QUESTION_NAME,{QUESTION_STATEMENT},QUOTE(QUESTION_COND),{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
};

[ADDON_TITLE, HINT_ID, HINT_NAME, {HINT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[ADDON_TITLE, QUESTION_ID, QUESTION_NAME, {QUESTION_KEYCODE}, ""] call CBA_fnc_addKeybind;
[ADDON_TITLE, MARK_ID, MARK_NAME, {MARK_KEYCODE}, ""] call CBA_fnc_addKeybind;
