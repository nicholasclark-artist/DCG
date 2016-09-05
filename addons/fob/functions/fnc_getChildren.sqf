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
	_action = [DEPLOY_ID, DEPLOY_NAME, "", {DEPLOY_STATEMENT}, {DEPLOY_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [REQUEST_ID, REQUEST_NAME, "", {REQUEST_STATEMENT}, {REQUEST_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [DISMANTLE_ID, DISMANTLE_NAME, "", {DISMANTLE_STATEMENT}, {DISMANTLE_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [PATROL_ID, PATROL_NAME, "", {PATROL_STATEMENT}, {PATROL_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [RECON_ID, RECON_NAME, "", {RECON_STATEMENT}, {RECON_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [BUILD_ID, BUILD_NAME, "", {BUILD_STATEMENT}, {BUILD_COND}, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];
} else {
	_action = player addAction [DEPLOY_NAME, {DEPLOY_STATEMENT}, [], 0, false, true, "", QUOTE(DEPLOY_COND)];
	_actions pushBack _action;

	_action = player addAction [REQUEST_NAME, {REQUEST_STATEMENT}, [], 0, false, true, "", QUOTE(REQUEST_COND)];
	_actions pushBack _action;

	_action = player addAction [DISMANTLE_NAME, {DISMANTLE_STATEMENT}, [], 0, false, true, "", QUOTE(DISMANTLE_COND)];
	_actions pushBack _action;

	_action = player addAction [PATROL_NAME, {PATROL_STATEMENT}, [], 0, false, true, "", QUOTE(PATROL_COND)];
	_actions pushBack _action;

	_action = player addAction [RECON_NAME, {RECON_STATEMENT}, [], 0, false, true, "", QUOTE(RECON_COND)];
	_actions pushBack _action;

	_action = player addAction [BUILD_NAME, {BUILD_STATEMENT}, [], 0, false, true, "", QUOTE(BUILD_COND)];
	_actions pushBack _action;
};

_actions