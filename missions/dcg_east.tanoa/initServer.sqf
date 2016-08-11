/*
Author:
Nicholas Clark (SENSEI)

Description:
init order not guaranteed
__________________________________________________________________*/
if !(isClass (configfile >> "CfgPatches" >> "dcg_main")) exitWith {};

waitUntil {dcg_main}; // wait until main addon completes postInit

// misc
["Initialize"] call BIS_fnc_dynamicGroups;
createCenter dcg_main_enemySide;
dcg_main_enemySide setFriend [CIVILIAN, 1];
dcg_main_playerSide setFriend [CIVILIAN, 1];

// debug
if (dcg_main_debug isEqualTo 1) then {
	[{
		_allEnemy = {alive _x && {side _x isEqualTo dcg_main_enemySide}} count allUnits;
		_allCiv = {alive _x && {side _x isEqualTo CIVILIAN}} count allUnits;
		_allGrp = str (count allGroups);
		["dcg_mission",["Enemy Count: %1, Civilian Count: %2, Group Count: %3, Server FPS: %4, Mission Uptime: %5, Active SQF Scripts: %6",_allEnemy,_allCiv,_allGrp,round diag_fps,time,count diag_activeSQFScripts]] call dcg_main_fnc_log;
	}, 60, []] call CBA_fnc_addPerFrameHandler;
};