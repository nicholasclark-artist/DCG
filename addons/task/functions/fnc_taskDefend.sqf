/*
Author: SENSEI

Last modified: 10/17/2015

Description: defend supply cache

Return: nothing
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_name","_position","_size","_avgTownSize","_town","_posCache","_roads","_cacheArray","_vehArray","_cache","_pos","_dir","_transport","_grpWest","_posEnemy","_squad","_wp"];

_taskID = "defend";
_taskText = "Defend Cache";
_taskDescription = "";

if (FOB_CHECK) then {
	_name = "FOB Pirelli";
	_position = [getmarkerpos "DCG_fob_mrk",10,25] call DCG_fnc_findRandomPos;
	_size = getmarkersize "DCG_fob_border_mrk";
	_avgTownSize = _size*0.5;
	FOBLOCK
	_taskDescription = format ["A few hours ago, Command dispatched a convoy to %1. Upon arrival, the convoy was attacked by enemy forces. We have intel that our soldiers are holding out, but we're sending your team in to assist. Protect the supply cache and minimize friendly casualties.",_name];
} else {
	_town = DCG_locations select floor (random (count DCG_locations));
	_name = _town select 0;
	_position = _town select 1;
	_size = _town select 2;
	_avgTownSize = _size*0.5;
	_taskDescription = format ["Yesterday, FOB Falken sent in a request for supplies. A few hours ago, Command dispatched a convoy enroute to Falken. Somewhere in %1, the convoy was attacked by enemy forces. We have intel that our soldiers are holding out, but we're sending your team in to assist. Protect the supply cache and minimize friendly casualties.",_name];
};

DCG_waveGrp = grpNull;
DCG_waveThreshold = 0;
DCG_waveCount = 0;
DCG_waveFailed = false;

_position set [2,0];
_posCache = [_position, 0, _avgTownSize, 5] call DCG_fnc_findRandomPos;
_roads = _posCache nearRoads 50;
_cacheArray = [];
_vehArray = [];

for "_c" from 0 to 1 do {
	_cache = "Box_NATO_AmmoVeh_F" createVehicle _posCache;
	_cache allowDamage false;
	_cache setVectorUp [0,0,1];
	_cacheArray pushBack _cache;
	_dir = random 360;
	_pos = [_posCache, 0, 30, 7] call DCG_fnc_findRandomPos;
	_transport = (DCG_vehPoolWest select floor (random (count DCG_vehPoolWest))) createVehicle [0,0,0];
	_transport setDir _dir;
	_transport setPosATL _pos;
	_transport setVectorUp [0,0,1];
	_vehArray pushBack _transport;
};

_grpWest = [_posCache,0,4,WEST] call DCG_fnc_spawnGroup;
[_grpWest] call DCG_fnc_setPatrolGroup;

TASKWPOS(_taskID,_taskDescription,_taskText,_posCache,"Defend")

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_posCache","_grpWest","_cacheArray","_vehArray"];

	if !(([_posCache,MAXDIST] call DCG_fnc_getNearPlayers) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_posCache","_grpWest","_cacheArray","_vehArray"];

			if (DCG_waveFailed) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
			};
			if (DCG_waveCount >= 3 && {count (units DCG_waveGrp) <= DCG_waveThreshold}) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				FOBUNLOCK
				[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
				_cacheArray call DCG_fnc_cleanup;
				_vehArray call DCG_fnc_cleanup;
				(units _grpWest) call DCG_fnc_cleanup;
				(units DCG_waveGrp) call DCG_fnc_cleanup;
				DCG_waveGrp = nil;
				DCG_waveThreshold = nil;
				DCG_waveCount = nil;
				call DCG_fnc_setTask;
			};
			if (count (units DCG_waveGrp) <= DCG_waveThreshold && {DCG_waveCount < 3}) then {
				DCG_waveCount = DCG_waveCount + 1;
				_squad = [[_posCache,500,550] call DCG_fnc_findRandomPos,DCG_enemySide,10,0.33] call DCG_fnc_spawnSquad;
				DCG_waveGrp = _squad select 2;
				DCG_waveThreshold = ceil ((count (units DCG_waveGrp))*0.30) max 1;
				SAD(DCG_waveGrp,_posCache)

				if !((_squad select 1) isEqualTo []) then {
					_wp = group ((_squad select 1) select 0) addWaypoint [_posCache, 0];
					_wp setWaypointCompletionRadius 60;
					_wp setWaypointType "MOVE";
					_wp setWaypointCombatMode "RED";
					vehicle ((_squad select 1) select 0) forceSpeed 25;
				};
				["Defend Supply Cache: Group count: %1, Wave count: %2, Wave threshold: %3", count (units DCG_waveGrp), DCG_waveCount, DCG_waveThreshold] call DCG_fnc_log;
			};
		}, 60, [_taskID,_posCache,_grpWest,_cacheArray,_vehArray]] call CBA_fnc_addPerFrameHandler;
		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_posCache","_grpWest","_cacheArray","_vehArray"];

			_nearUnits = _posCache nearEntities [["Man"], 10];
			if !(_nearUnits isEqualTo []) then {
				_unit = _nearUnits select floor (random (count _nearUnits));
				if (side _unit isEqualTo DCG_enemySide) then {
					DCG_waveFailed = true;
					_bombArray = ["R_TBG32V_F","HelicopterExploSmall"];
					(_bombArray select floor (random (count _bombArray))) createVehicle (getPosATL _unit);
					deleteVehicle _unit;
					[_idPFH] call CBA_fnc_removePerFrameHandler;
					FOBUNLOCK
					[_taskID, "FAILED"] call BIS_fnc_taskSetState;
					_cacheArray call DCG_fnc_cleanup;
					_vehArray call DCG_fnc_cleanup;
					(units _grpWest) call DCG_fnc_cleanup;
					(units DCG_waveGrp) call DCG_fnc_cleanup;
					DCG_waveGrp = nil;
					DCG_waveThreshold = nil;
					DCG_waveCount = nil;
					call DCG_fnc_setTask;
				};
			};
		}, 5, [_taskID,_posCache,_grpWest,_cacheArray,_vehArray]] call CBA_fnc_addPerFrameHandler;
	};
}, 10, [_taskID,_posCache,_grpWest,_cacheArray,_vehArray]] call CBA_fnc_addPerFrameHandler;