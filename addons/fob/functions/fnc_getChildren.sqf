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
#define SET_PATROL \
	{ \
		if (_x isKindOf 'Man' && {_x isEqualTo leader group _x} && {!(_x getVariable ['dcg_isOnPatrol',-1] isEqualTo 1)}) then { \
			[units group _x,GVAR(range)*0.5,false] call EFUNC(main,setPatrol); \
			_x addEventHandler ['Local',{ \
				if (_this select 1) then { \
					_x setVariable ['dcg_isOnPatrol',0]; \
					[units group (_this select 0),GVAR(range)*0.5,false] call EFUNC(main,setPatrol); \
				}; \
			}]; \
		}; \
	} forEach (curatorEditableObjects GVAR(curator));

#define DEPLOY_ID QUOTE(DOUBLES(ADDON,deploy))
#define DEPLOY_NAME format ["Deploy %1", GVAR(name)]
#define DEPLOY_STATEMENT {call FUNC(deploy)}
#define DEPLOY_COND QUOTE(call FUNC(canDeploy))

/*#define BUILD_ID QUOTE(DOUBLES(ADDON,build))
#define BUILD_NAME format ["Build %1", GVAR(name)]
#define BUILD_STATEMENT {openCuratorInterface}
#define BUILD_COND QUOTE(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))*/

#define REQUEST_ID QUOTE(DOUBLES(ADDON,request))
#define REQUEST_NAME format ["Request Control of %1", GVAR(name)]
#define REQUEST_STATEMENT {call FUNC(request)}
#define REQUEST_COND QUOTE(!(GVAR(location) isEqualTo locationNull) && {!(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))})

#define DISMANTLE_ID QUOTE(DOUBLES(ADDON,dismantle))
#define DISMANTLE_NAME format ["Dismantle %1", GVAR(name)]
#define DISMANTLE_STATEMENT {call FUNC(delete)}
#define DISMANTLE_COND QUOTE(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))

#define PATROL_ID QUOTE(DOUBLES(ADDON,patrol))
#define PATROL_NAME "Set FOB Groups on Patrol"
#define PATROL_STATEMENT {SET_PATROL}
#define PATROL_COND QUOTE(player isEqualTo (getAssignedCuratorUnit GVAR(curator)))

private ["_actions","_action"];

_actions = [];

if (CHECK_ADDON_1("ace_interact_menu")) then {
	_action = [DEPLOY_ID, DEPLOY_NAME, "", DEPLOY_STATEMENT, compile DEPLOY_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	/*_action = [BUILD_ID, BUILD_NAME, "", BUILD_STATEMENT, compile BUILD_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];*/

	_action = [REQUEST_ID, REQUEST_NAME, "", REQUEST_STATEMENT, compile REQUEST_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [DISMANTLE_ID, DISMANTLE_NAME, "", DISMANTLE_STATEMENT, compile DISMANTLE_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];

	_action = [PATROL_ID, PATROL_NAME, "", PATROL_STATEMENT, compile PATROL_COND, {}, []] call ace_interact_menu_fnc_createAction;
	_actions pushBack [_action, [], player];
} else {
	_action = player addAction [DEPLOY_NAME, DEPLOY_STATEMENT, [], 0, false, true, "", DEPLOY_COND];
	_actions pushBack _action;

	/*_action = player addAction [BUILD_NAME, BUILD_STATEMENT, [], 0, false, true, "", BUILD_COND];
	_actions pushBack _action;*/

	_action = player addAction [REQUEST_NAME, REQUEST_STATEMENT, [], 0, false, true, "", REQUEST_COND];
	_actions pushBack _action;

	_action = player addAction [DISMANTLE_NAME, DISMANTLE_STATEMENT, [], 0, false, true, "", DISMANTLE_COND];
	_actions pushBack _action;

	_action = player addAction [PATROL_NAME, PATROL_STATEMENT, [], 0, false, true, "", PATROL_COND];
	_actions pushBack _action;
};

_actions