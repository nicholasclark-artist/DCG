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

[QUOTE(ADDON),"Forward Operating Base",{},QUOTE(true),{call FUNC(getChildren)}] call EFUNC(main,setAction);

// if ace interaction menu is enabled add transfer action to receiving unit's menu, instead of self menu
if (CHECK_ADDON_1("ace_interact_menu")) then {
    _action = [TRANSFER_ID, TRANSFER_NAME, "", {TRANSFER_STATEMENT_ACE}, {TRANSFER_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
};

player addEventHandler ["Respawn",{
    if ((_this select 1) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
        [
            {
                missionNamespace setVariable [PVEH_ASSIGN,player];
                publicVariableServer PVEH_ASSIGN;
            },
            [],
            5
        ] call CBA_fnc_waitAndExecute;
    };
}];

INFO("Client setup finished");
