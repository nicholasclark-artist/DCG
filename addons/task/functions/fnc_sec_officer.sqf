/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - kill officer

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Eliminate Officer'
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_strength = TASK_STRENGTH;

if (_position isEqualTo []) then {
	if !(EGVAR(main,locals) isEqualTo []) then {
		_position = (selectRandom EGVAR(main,locals)) select 1;
		if !([_position,0.5,0] call EFUNC(main,isPosSafe)) then {
			_position = [];
		};
	} else {
		_position = [EGVAR(main,center),EGVAR(main,range),"forest",0,true] call EFUNC(main,findPosTerrain);
	};
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
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
};

if !([_position,1,0] call EFUNC(main,isPosSafe)) then {
	_position = [_position,5,50,1,0] call EFUNC(main,findPosSafe);
};

_base = [_position,random 0.2] call EFUNC(main,spawnBase);
_bRadius = _base select 0;

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, ASLtoAGL _position, [], 0, "NONE"];
[group _officer,_position,_bRadius*0.5,2,false] call CBA_fnc_taskDefend;

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength"];

        [_grp,_grp,_bRadius,2,false] call CBA_fnc_taskDefend;
	},
	[_grp,_bRadius,_strength]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = "A low ranking enemy officer has been spotted nearby. Find and eliminate the officer.";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"kill"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_grp","_base","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base) call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		((units _grp) + [_officer] + _base) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_officer,_grp,_base select 2,_position]] call CBA_fnc_addPerFrameHandler;
