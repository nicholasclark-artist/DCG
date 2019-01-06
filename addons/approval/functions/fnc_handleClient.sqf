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
    [QGVAR(hint),AP_HINT_NAME,{AP_HINT_STATEMENT},{AP_HINT_COND},{},[],player,1,ACTIONPATH]
];

if (CHECK_ADDON_1("ace_interact_menu")) then {
    private _action = [QGVAR(stop), AP_HALT_NAME, "", {AP_HALT_STATEMENT_ACE}, {AP_HALT_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
    private _action = [QGVAR(question), AP_QUESTION_NAME, "", {AP_QUESTION_STATEMENT_ACE}, {AP_QUESTION_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
} else {
    [QGVAR(stop),AP_HALT_NAME,{AP_HALT_STATEMENT},{AP_HALT_COND},{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
    [QGVAR(question),AP_QUESTION_NAME,{AP_QUESTION_STATEMENT},{AP_QUESTION_COND},{},[],player,1,ACTIONPATH] call EFUNC(main,setAction);
};

[COMPONENT_NAME, QGVAR(hint), AP_HINT_NAME, {AP_HINT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(stop), AP_HALT_NAME, {AP_HALT_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(question), AP_QUESTION_NAME, {AP_QUESTION_KEYCODE}, ""] call CBA_fnc_addKeybind;
