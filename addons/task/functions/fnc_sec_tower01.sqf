/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - destroy tower

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Destroy Communications Tower'
#define TOWER "Land_TTowerBig_2_F"
#include "script_component.hpp"

params [
    ["_pos",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_strength = TASK_STRENGTH;
_cleanup = [];

if (!(EGVAR(main,hills) isEqualTo []) && {_pos isEqualTo []}) then {
	_hillPos = (selectRandom EGVAR(main,hills)) select 0;
	_pos = [_hillPos,0,100,6,0,1] call EFUNC(main,findPosSafe);
	if (_pos isEqualTo _hillPos) then {
		_pos = [];
	};
};

if (_pos isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_tower = TOWER createVehicle _pos;
_tower setPosATL [(getposATL _tower) select 0,(getposATL _tower) select 1,-1];
_tower setVectorUp [0,0,1];
_cleanup pushBack _tower;
[_tower] call FUNC(handleDamage);

_grp = [_pos,0,_strength,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 1)},
	{
		params ["_grp","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup patrols
        for "_i" from 0 to (count units _grp) - 1 step TASK_PATROL_UNITCOUNT do {
            _patrolGrp = createGroup EGVAR(main,enemySide);
            ((units _grp) select [0,TASK_PATROL_UNITCOUNT]) joinSilent _patrolGrp;
            [_patrolGrp, _patrolGrp, 50 + random 50, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol;
        };
	},
	[_grp,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = "";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_pos,false,true,"destroy"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_pos);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_pos","_cleanup"];

	if (GVAR(secondary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _tower) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_pos,TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_pos,_cleanup]] call CBA_fnc_addPerFrameHandler;
