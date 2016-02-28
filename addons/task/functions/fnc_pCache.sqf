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
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define MRK_DIST 350
#define ENEMY_MINCOUNT 8
#define ENEMY_MAXCOUNT 20

private ["_caches","_base","_drivers","_grp","_cache","_taskID","_taskDescription","_taskTitle","_taskPos","_mrk"];
params [["_position",[]]];

_caches = [];
_base = [];
_drivers = [];
_grp = grpNull;

// CREATE TASK
if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findRuralPos);
};

if (_position isEqualTo []) exitWith {
	[1,0] spawn FUNC(select);
};

_base = [_position,0.5 + random 0.5] call EFUNC(main,spawnBase);
_position = [_position,0,15,0.5] call EFUNC(main,findRandomPos);

for "_i" from 0 to 2 do {
	_cache = "O_supplyCrate_F" createVehicle _position;
	_cache setDir random 360;
	_caches pushBack _cache;
	_cache addEventHandler ["HandleDamage", {
		if ((_this select 4) isKindof "PipeBombBase" && {(_this select 2) > 0.6}) then {
			(_this select 0) setdamage 1;
		};
	}];
};

_grp = [_position,0,[ENEMY_MINCOUNT,ENEMY_MAXCOUNT] call EFUNC(main,setStrength),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
[units _grp] call EFUNC(main,setPatrol);

if (random 1 < 0.5) then {
	_drivers = [[_position,0,200,6] call EFUNC(main,findRandomPos),1,1,EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
	[_drivers,500] call EFUNC(main,setPatrol);
};

// SET TASK
_taskPos = [_position,MRK_DIST*0.85,MRK_DIST] call EFUNC(main,findRandomPos);
_taskID = format ["pCache_%1",diag_tickTime];
_taskTitle = "(P) Destroy Cache";
_taskDescription = format ["An enemy camp housing an ammunitions cache has been spotted near %1. These supplies are critical to the opposition's efforts. Destroy the cache and weaken the enemy.", mapGridPosition _taskPos];

[true,_taskID,[_taskDescription,_taskTitle,""],_taskPos,false,true,"Attack"] call EFUNC(main,setTask);

if (CHECK_DEBUG) then {
	_mrk = createMarker [format ["cache_%1", diag_tickTime],getpos (_caches select 0)];
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText "CACHE";
};

// PUBLISH TASK
GVAR(primary) = [QFUNC(pCache),_position];
publicVariable QGVAR(primary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_caches","_grp","_drivers","_base"];

	if (GVAR(primary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + _drivers + _caches + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if ({alive _x} count _caches isEqualTo 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		((units _grp) + _drivers + _caches + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};
}, HANDLER_SLEEP, [_taskID,_caches,_grp,_drivers,_base]] call CBA_fnc_addPerFrameHandler;