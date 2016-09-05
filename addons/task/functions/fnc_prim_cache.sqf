/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - destroy cache

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Destroy Cache'
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_caches = [];
_base = [];
_strength = [TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength);
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findPosRural);
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

_base = [_position,0.47 + random 0.3] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_bNodes = _base select 3;

if (_bNodes isEqualTo []) exitWith {
	(_base select 2) call EFUNC(main,cleanup);
	[TASK_TYPE,0] call FUNC(select);
};

_posCache = selectRandom _bNodes;
_posCache = _posCache select 0;

for "_i" from 0 to 1 do {
	_cache = "O_supplyCrate_F" createVehicle _posCache;
	_cache setDir random 360;
	_cache setVectorUp surfaceNormal getPos _cache;
	_caches pushBack _cache;
/*	_cache addEventHandler ["HandleDamage", {
		_ret = 0;
		if ((_this select 4) isKindof "PipeBombBase") then {
			_ret = 1;
		} else {
			_ret = 0;
		};

		_ret
	}];*/
};

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);

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
};

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = format ["An enemy camp housing an ammunitions cache has been spotted near %1. These supplies are critical to the opposition's efforts. Destroy the cache and weaken the enemy.", mapGridPosition _taskPos];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"destroy"] call EFUNC(main,setTask);

TASK_DEBUG(_posCache);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_caches","_grp","_vehGrp","_base","_posCache"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + (units _vehGrp) + [vehicle leader _vehGrp] + _caches + _base) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if ({alive _x} count _caches isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		((units _grp) + (units _vehGrp) + [vehicle leader _vehGrp] + _caches + _base) call EFUNC(main,cleanup);
		TASK_APPROVAL(_posCache,TASK_AV);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_caches,_grp,_vehGrp,_base select 2,_posCache]] call CBA_fnc_addPerFrameHandler;