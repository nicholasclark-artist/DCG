/*
Author: SENSEI

Last modified: 12/23/2015

Description: get action children

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define DEPLOY_ID QUOTE(DOUBLES(ADDON,deploy))
#define DEPLOY_NAME format ["Deploy %1", GVAR(name)]
#define DEPLOY_STATEMENT {call FUNC(deploy)}
#define DEPLOY_COND QUOTE(call FUNC(canDeploy))

#define REQUEST_ID QUOTE(DOUBLES(ADDON,request))
#define REQUEST_NAME format ["Request Control of %1", GVAR(name)]
#define REQUEST_STATEMENT {call FUNC(request)}
#define REQUEST_COND QUOTE(!(GVAR(location) isEqualTo locationNull) && {!(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))})

#define DISMANTLE_ID QUOTE(DOUBLES(ADDON,dismantle))
#define DISMANTLE_NAME format ["Dismantle %1", GVAR(name)]
#define DISMANTLE_STATEMENT {remoteExecCall [QFUNC(delete), 2, false]}
#define DISMANTLE_COND QUOTE(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))

private ["_actions","_action"];

_actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_action = [DEPLOY_ID, DEPLOY_NAME, "", DEPLOY_STATEMENT, compile DEPLOY_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [REQUEST_ID, REQUEST_NAME, "", REQUEST_STATEMENT, compile REQUEST_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [DISMANTLE_ID, DISMANTLE_NAME, "", DISMANTLE_STATEMENT, compile DISMANTLE_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];
} else {
	_action = player addAction [DEPLOY_NAME, DEPLOY_STATEMENT, [], 0, false, true, "", DEPLOY_COND];
	_actions pushBack _action;

	_action = player addAction [REQUEST_NAME, REQUEST_STATEMENT, [], 0, false, true, "", REQUEST_COND];
	_actions pushBack _action;

	_action = player addAction [DISMANTLE_NAME, DISMANTLE_STATEMENT, [], 0, false, true, "", DISMANTLE_COND];
	_actions pushBack _action;
};

_actions