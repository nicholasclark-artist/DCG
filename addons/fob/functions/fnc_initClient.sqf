/*
Author:
Nicholas Clark (SENSEI)

Description:
handle client setup

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

if (!hasInterface) exitWith {};

[QUOTE(ADDON),"Forward Operating Base",{},{true},{call FUNC(getChildren)}] call EFUNC(main,setAction);

// if ace interaction menu is enabled add transfer action to receiving unit's menu, instead of self menu
if (CHECK_ADDON_1(ace_interact_menu)) then {
    _action = [QGVAR(transfer), FOB_TRANSFER_NAME, "", {FOB_TRANSFER_STATEMENT_ACE}, {FOB_TRANSFER_COND_ACE}, {}, []] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 0, ["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
};

[COMPONENT_NAME, QGVAR(create), FOB_CREATE_NAME, {FOB_CREATE_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(delete), FOB_DELETE_NAME, {FOB_DELETE_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(transfer), FOB_TRANSFER_NAME, {FOB_TRANSFER_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(control), FOB_CONTROL_NAME, {FOB_CONTROL_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(recon), FOB_RECON_NAME, {FOB_RECON_KEYCODE}, ""] call CBA_fnc_addKeybind;
[COMPONENT_NAME, QGVAR(build), FOB_BUILD_NAME, {FOB_BUILD_KEYCODE}, "", [DIK_DOWN, [true, false, false]]] call CBA_fnc_addKeybind;

player addEventHandler ["Respawn",{
    if ((_this select 1) isEqualTo getAssignedCuratorUnit GVAR(curator)) then {
        [CBA_fnc_serverEvent, [QGVAR(assign), [GVAR(curator), player]], 5] call CBA_fnc_waitAndExecute;
    };
}];

nil