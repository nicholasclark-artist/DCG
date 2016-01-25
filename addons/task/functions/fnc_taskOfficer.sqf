/*
Author: Nicholas Clark (SENSEI)

Description:
officer task

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_position","_action","_args"];

_taskID = "officer";
_taskText = "Locate Officer";
_taskDescription = "A high ranking enemy officer will be traveling to an occupied settlement today.<br/><br/>Find the officer and gather any relevant intel.";

_position = (DCG_occupiedLocations select floor (random (count DCG_occupiedLocations))) select 1;
DCG_officer = (createGroup DCG_enemySide) createUnit [DCG_officerPool select floor (random (count DCG_officerPool)),[_position,0,30,0.5] call DCG_fnc_findRandomPos, [], 0, "NONE"];
publicVariable "DCG_officer";
removeFromRemainsCollector [DCG_officer];

DCG_officer addEventHandler ["hit", {
	(_this select 0) removeAllEventHandlers "hit";
	if (alive (_this select 0)) then {
		[(_this select 0)] call DCG_fnc_setUnitSurrender;
	};
}];

[[],{
	_action = ["DCG_OfficerIntel","Search Officer for Intel","",{
		[
			10,
			[],
			{
				DCG_taskSuccess = 1;
				publicVariableServer "DCG_taskSuccess";
				hintSilent "You found valuable intel.";
			},
			{

			},
			"Searching Officer..."
		] call ace_common_fnc_progressBar;
	},{true}] call ace_interact_menu_fnc_createAction;
	[DCG_officer, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
}] remoteExecCall ["BIS_fnc_call", west, true];

[group DCG_officer,70] call DCG_fnc_setPatrolGroup;

TASK(_taskID,_taskDescription,_taskText,"Search")

if(CHECK_DEBUG) then {
	[_taskID,getPosATL DCG_officer] call BIS_fnc_taskSetDestination;
};

[{
	params ["_args","_idPFH"];
	_args params ["_taskID"];

	if (DCG_taskSuccess isEqualTo 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		deleteVehicle DCG_officer;
		call DCG_fnc_setTask;
	};
}, 1, [_taskID]] call CBA_fnc_addPerFrameHandler;