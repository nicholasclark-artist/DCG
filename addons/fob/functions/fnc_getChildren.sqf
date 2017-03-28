/*
Author:
Nicholas Clark (SENSEI)

Description:
get action children

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_action"];
private _actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_action = [CREATE_ID, CREATE_NAME, "", {CREATE_STATEMENT}, {CREATE_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	// _action = [TRANSFER_ID, TRANSFER_NAME, "", {TRANSFER_STATEMENT}, {TRANSFER_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	// _actions pushBack [_action, [], player];

    _action = [CONTROL_ID, CONTROL_NAME, "", {CONTROL_STATEMENT}, {CONTROL_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [DELETE_ID, DELETE_NAME, "", {DELETE_STATEMENT}, {DELETE_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [RECON_ID, RECON_NAME, "", {RECON_STATEMENT}, {RECON_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [BUILD_ID, BUILD_NAME, "", {BUILD_STATEMENT}, {BUILD_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];
} else {
	_action = player addAction [CREATE_NAME, {CREATE_STATEMENT}, [], 0, false, true, "", QUOTE(CREATE_COND)];
	_actions pushBack _action;

	_action = player addAction [TRANSFER_NAME, {TRANSFER_STATEMENT}, [], 0, false, true, "", QUOTE(TRANSFER_COND)];
	_actions pushBack _action;

    _action = player addAction [CONTROL_NAME, {CONTROL_STATEMENT}, [], 0, false, true, "", QUOTE(CONTROL_COND)];
	_actions pushBack _action;

	_action = player addAction [DELETE_NAME, {DELETE_STATEMENT}, [], 0, false, true, "", QUOTE(DELETE_COND)];
	_actions pushBack _action;

	_action = player addAction [RECON_NAME, {RECON_STATEMENT}, [], 0, false, true, "", QUOTE(RECON_COND)];
	_actions pushBack _action;

	_action = player addAction [BUILD_NAME, {BUILD_STATEMENT}, [], 0, false, true, "", QUOTE(BUILD_COND)];
	_actions pushBack _action;
};

_actions
