/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_ADDON_1("dcg_main")) exitWith {};

waitUntil {DOUBLES(PREFIX,main)}; // wait until main addon completes postInit

// misc
["Initialize"] call BIS_fnc_dynamicGroups; // BIS group management
createCenter EGVAR(main,enemySide); // required if an enemy side unit is not placed in editor

// debug
if (CHECK_DEBUG) then {
	[{
		_allEnemy = {alive _x && {side _x isEqualTo EGVAR(main,enemySide)}} count allUnits;
		_allCiv = {alive _x && {side _x isEqualTo CIVILIAN}} count allUnits;
		_allGrp = str (count allGroups);
		LOG_DEBUG_5("Enemy Count: %1, Civilian Count: %2, Group Count: %3, Server FPS: %4, Mission Uptime: %5",_allEnemy,_allCiv,_allGrp,round diag_fps,time);
	}, 60, []] call CBA_fnc_addPerFrameHandler;
};

// arsenal
waitUntil {!isNil "bis_fnc_arsenal_data"};

_data = missionnamespace getVariable "bis_fnc_arsenal_data"; // remove items from communications tab
_data set [12,[]];
missionnamespace setVariable ["bis_fnc_arsenal_data",_data,true];