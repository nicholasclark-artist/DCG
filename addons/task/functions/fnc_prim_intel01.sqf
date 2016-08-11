/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - Steal Intel

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
/*#define TASK_PRIMARY
#define TASK_NAME 'Steal Intel'
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_drivers = [];
_classes = [];

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findRuralPos);
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

_base = [_position,1] call EFUNC(main,spawnBase);
_bRadius = _base select 0;

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findRandomPos));
_taskDescription = format ["A high ranking enemy officer has been spotted near %1. Find and eliminate the officer.",mapGridPosition _taskPos];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"kill"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_grp","_drivers","_base"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base + _drivers) call EFUNC(main,cleanup);
		[TASK_TYPE] call FUNC(select);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base + _drivers) call EFUNC(main,cleanup);
		TASK_APPROVAL(getPos _officer,TASK_AV);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_officer,_grp,_drivers,_base select 2]] call CBA_fnc_addPerFrameHandler;*/