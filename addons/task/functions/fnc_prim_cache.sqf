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

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_caches = [];
_base = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPosTerrain);
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_base = [_position,0.47 + random 0.3] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_bNodes = _base select 3;

if (_bNodes isEqualTo []) exitWith {
	(_base select 2) call EFUNC(main,cleanup);
	TASK_EXIT_DELAY(0);
};

_cleanup append (_base select 2);

_posCache = selectRandom _bNodes;
_posCache = _posCache select 0;

for "_i" from 0 to 1 do {
	_cache = "O_supplyCrate_F" createVehicle _posCache;
	_cache setDir random 360;
	_cache setVectorUp surfaceNormal getPos _cache;
    [_cache] call FUNC(handleDamage);
	_cleanup pushBack _cache;
};

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength","_cleanup"];

        _cleanup append (units _grp);

        // regroup garrison units
        _garrisonGrp = createGroup EGVAR(main,enemySide);
        ((units _grp) select [0,TASK_GARRISONCOUNT]) joinSilent _garrisonGrp;
        [_garrisonGrp,_garrisonGrp,_bRadius,1,false] call CBA_fnc_taskDefend;

        // regroup patrols
        for "_i" from 0 to (count units _grp) - 1 step TASK_PATROL_UNITCOUNT do {
            _patrolGrp = createGroup EGVAR(main,enemySide);
            ((units _grp) select [0,TASK_PATROL_UNITCOUNT]) joinSilent _patrolGrp;
            [_patrolGrp, _patrolGrp, _bRadius, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol;
        };
	},
	[_grp,_bRadius,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,60,200,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY,true] call EFUNC(main,spawnGroup);

	[
		{{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
		{
            params ["_position","_vehGrp","_bRadius"];

            _cleanup pushBack (objectParent leader _vehGrp);
            _cleanup append (units _vehGrp);

			[_vehGrp, _position, _bRadius*2, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol;
		},
		[_position,_vehGrp,_bRadius]
	] call CBA_fnc_waitUntilAndExecute;
};

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = "An enemy base, housing an ammunitions cache, has been located nearby. These supplies are critical to the opposition's efforts, destroy the cache and weaken the enemy supply lines.";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"destroy"] call EFUNC(main,setTask);

TASK_DEBUG(_posCache);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_cleanup","_posCache"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if ({alive _x} count _cleanup isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_APPROVAL(_posCache,TASK_AV);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_cleanup,_posCache]] call CBA_fnc_addPerFrameHandler;
