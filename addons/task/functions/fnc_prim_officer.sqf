/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - kill officer

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Eliminate Officer'
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_strength = [TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength);
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findPosRural);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_classes = EGVAR(main,officerPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_classes = EGVAR(main,officerPoolWest);
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_classes = EGVAR(main,officerPoolInd);
	};

	_classes = EGVAR(main,officerPoolEast);
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

_base = [_position,0.65 + random 1] call EFUNC(main,spawnBase);
_bRadius = _base select 0;

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, ASLtoAGL _position, [], 0, "NONE"];
removeFromRemainsCollector [_officer];
[[_officer],_bRadius] call EFUNC(main,setPatrol);

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
		[units (_this select 0),_this select 1] call EFUNC(main,setPatrol);
	},
	[_grp,_bRadius,_strength]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,100,200,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),false,1,true] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
		{
			[units (_this select 0),((_this select 1)*4 min 300) max 100] call EFUNC(main,setPatrol);
		},
		[_vehGrp,_bRadius]
	] call CBA_fnc_waitUntilAndExecute;
} else {
	_vehGrp = [_vehPos,2,1,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
		{
			[units (_this select 0),1200] call EFUNC(main,setPatrol);
		},
		[_vehGrp,_bRadius]
	] call CBA_fnc_waitUntilAndExecute;
};

TASK_DEBUG(getPos _officer);

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = format ["A high ranking enemy officer has been spotted near %1. Find and eliminate the officer.",mapGridPosition _taskPos];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"kill"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_grp","_vehGrp","_base","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base + (units _vehGrp) + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		((units _grp) + [_officer] + _base + (units _vehGrp) + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_officer,_grp,_vehGrp,(_base select 2),_position]] call CBA_fnc_addPerFrameHandler;