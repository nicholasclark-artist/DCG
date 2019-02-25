/*
Author:
Nicholas Clark (SENSEI)

Description:
get action children

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_action"];
private _actions = [];

if (CHECK_ADDON_1(ace_interact_menu)) then {
    _action = [QGVAR(create), FOB_CREATE_NAME, "", {FOB_CREATE_STATEMENT}, {FOB_CREATE_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], player];

    // _action = [QGVAR(transfer), FOB_TRANSFER_NAME, "", {FOB_TRANSFER_STATEMENT}, {FOB_TRANSFER_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    // _actions pushBack [_action, [], player];

    _action = [QGVAR(control), FOB_CONTROL_NAME, "", {FOB_CONTROL_STATEMENT}, {FOB_CONTROL_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], player];

    _action = [QGVAR(delete), FOB_DELETE_NAME, "", {FOB_DELETE_STATEMENT}, {FOB_DELETE_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], player];

    _action = [QGVAR(recon), FOB_RECON_NAME, "", {FOB_RECON_STATEMENT}, {FOB_RECON_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], player];

    _action = [QGVAR(build), FOB_BUILD_NAME, "", {FOB_BUILD_STATEMENT}, {FOB_BUILD_COND}, {}, []] call ace_interact_menu_fnc_createAction;
    _actions pushBack [_action, [], player];
} else {
    _action = player addAction [FOB_CREATE_NAME, {FOB_CREATE_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_CREATE_COND)];
    _actions pushBack _action;

    _action = player addAction [FOB_TRANSFER_NAME, {FOB_TRANSFER_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_TRANSFER_COND)];
    _actions pushBack _action;

    _action = player addAction [FOB_CONTROL_NAME, {FOB_CONTROL_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_CONTROL_COND)];
    _actions pushBack _action;

    _action = player addAction [FOB_DELETE_NAME, {FOB_DELETE_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_DELETE_COND)];
    _actions pushBack _action;

    _action = player addAction [FOB_RECON_NAME, {FOB_RECON_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_RECON_COND)];
    _actions pushBack _action;

    _action = player addAction [FOB_BUILD_NAME, {FOB_BUILD_STATEMENT}, [], 0, false, true, "", QUOTE(FOB_BUILD_COND)];
    _actions pushBack _action;
};

_actions
