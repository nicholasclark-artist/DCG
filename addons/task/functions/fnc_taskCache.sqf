/*
Author: Nicholas Clark (SENSEI)

Last modified: 9/16/2015

Description: destroy ammo cache

Return: nothing
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_pos","_cacheArray","_radius","_grpArray","_baseArray","_vehArray","_grp","_hq","_ammo","_posMrk","_mrk"];

_taskID = "cache";
_taskText = "Destroy Cache";
_taskDescription = "According to intel, a small enemy camp is housing an ammunitions cache that is critical to the opposition's efforts. Your team is tasked with destorying the cache.";

_pos = [];
_cacheArray = [];
_radius = 1000;

_pos = [DCG_centerPos,DCG_range,70] call DCG_fnc_findRuralFlatPos;
if (_pos isEqualTo []) exitWith {
	TASKEXIT(_taskID)
};
_grpArray = [_pos,DCG_enemySide,12,.25,1] call DCG_fnc_spawnSquad;
_baseArray = _grpArray select 0;
_vehArray = _grpArray select 1;
_grp = _grpArray select 2;
_hq = nearestObjects [_pos, ["Land_Cargo_HQ_V3_F"], 100];
_hq = (_hq select floor (random (count _hq)));

for "_i" from 0 to 2 step 2 do {
	_ammo = "O_supplyCrate_F" createVehicle [0,0,0];
	_ammo setDir getDir _hq;
	_ammo setPosATL (_hq modelToWorld [4,1 + _i,-2.6]);
	_cacheArray pushBack _ammo;
	_ammo addEventHandler ["HandleDamage", {
		if ((_this select 4) isKindof "PipeBombBase" && {(_this select 2) > 0.6}) then {(_this select 0) setdamage 1};
	}];
};

[_grp] call DCG_fnc_setPatrolGroup;
if !(_vehArray isEqualTo []) then {
	[_vehArray select 0,300] call DCG_fnc_setPatrolVeh;
};

_posMrk = [_pos,100,_radius] call DCG_fnc_findRandomPos;
_mrk = createMarker ["DCG_cache_AO",_posMrk];
_mrk setMarkerColor "ColorRED";
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerAlpha 0.7;
_mrk setMarkerSize [_radius,_radius];

TASK(_taskID,_taskDescription,_taskText,"Destroy")

if(CHECK_DEBUG) then {
	[_taskID,_pos] call BIS_fnc_taskSetDestination;
};

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_cacheArray","_baseArray","_mrk"];

	if ({(damage _x) > 0.95} forEach _cacheArray) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		{deleteVehicle _x} forEach _cacheArray;
		_baseArray call DCG_fnc_cleanup;
		_mrk call DCG_fnc_cleanup;
		call DCG_fnc_setTask;
	};
}, 5, [_taskID,_cacheArray,_baseArray,_mrk]] call CBA_fnc_addPerFrameHandler;