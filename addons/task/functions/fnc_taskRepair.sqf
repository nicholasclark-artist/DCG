/*
Author:
Nicholas Clark (SENSEI)

Description:
repair patrol vehicles

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_taskID","_taskText","_taskDescription","_vehArray","_size","_position","_town","_veh","_grp","_check","_alive"];

_taskID = "repair";
_taskText = "Repair Patrol";
_taskDescription = "";
_vehArray = [];

if (FOB_CHECK) then {
	_name = "FOB Pirelli";
	_size = getmarkersize "DCG_fob_border_mrk";
	_position = [getmarkerpos "DCG_fob_mrk",_size + 100,_size + 400,7] call DCG_fnc_findRandomPos;
	FOBLOCK
	_taskDescription = format ["Intel shows that enemy forces plan to attack %1 in the coming days. In response, Command has increased the frequency of patrols in the area. A friendly unit scouting around %1 is in need of repair supplies. Make sure our soldiers are in top shape. Gather the necessary supplies and repair the patrol vehicles.",_name];
} else {
	_town = DCG_locations select floor (random (count DCG_locations));
	_name = _town select 0;
	_position = _town select 1;
	_size = _town select 2;

	_position = [_position,_size + 100,_size + 400,7] call DCG_fnc_findRandomPos;
	_taskDescription = format ["Intel shows that another local settlement will be occupied in the coming days. Command has increased the frequency of patrols in several key areas. A friendly unit scouting near %1 is in need of repair supplies. Make sure our soldiers are in top shape. Gather the necessary supplies and repair the patrol vehicles.",_name];
};

_vehSelect = [];
// TODO: remove check once RG33 is ACE repair compatible
{
	if !(_x select [0,11] isEqualTo "rhsusf_rg33") then {_vehSelect pushBack _x};
} forEach DCG_vehPoolWest;
if (_vehSelect isEqualTo []) then {
	_vehSelect = ["B_mrap_01_F","B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"];
};

for "_i" from 0 to 1 do {
	_veh = (_vehSelect select floor (random (count _vehSelect))) createVehicle ([_position, 0, 30, 6, 0, 0.6, 0,[],[_position,_position]] call BIS_fnc_findSafePos);
	_veh setVectorUp [0,0,1];
	_veh setDir (random 360);
	[_veh] call DCG_fnc_setVehDamaged;
	_vehArray pushback _veh;
};

_grp = [_position,0,6,WEST] call DCG_fnc_spawnGroup;

TASKWPOS(_taskID,_taskDescription,_taskText,_position,"Support")

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vehArray","_grp","_position"];

	if !(([_position,MAXDIST] call DCG_fnc_getNearPlayers) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		if (random 1 < 0.50) then {
			[_position,DCG_enemySide] spawn DCG_fnc_spawnReinforcements;
		} else {
			private "_grp";
			_grp = [[_position,400,500] call DCG_fnc_findRandomPos,0,STRENGTH(8,16)] call DCG_fnc_spawnGroup;
			SAD(_grp,_position)
		};
		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_vehArray","_grp","_position"];

			_alive = true;
			_check = true;

			for "_i" from 0 to ((count _vehArray) - 1) do {
				if (!alive (_vehArray select _i)) exitWith {
					_alive = false;
				};
				if ({_x isEqualTo 1} count ((getAllHitPointsDamage (_vehArray select _i)) select 2) > 0) exitWith {
					_check = false;
				};
			};
			if !(_alive) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "FAILED"] call BIS_fnc_taskSetState;
				_vehArray call DCG_fnc_cleanup;
				(units _grp) call DCG_fnc_cleanup;
				[_position,50] call DCG_fnc_removeParticle;
				FOBUNLOCK
				call DCG_fnc_setTask;
			};
			if (_check) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
				_vehArray call DCG_fnc_cleanup;
				(units _grp) call DCG_fnc_cleanup;
				FOBUNLOCK
				call DCG_fnc_setTask;
			};
		}, 10, [_taskID,_vehArray,_grp,_position]] call CBA_fnc_addPerFrameHandler;
	};
}, 10, [_taskID,_vehArray,_grp,_position]] call CBA_fnc_addPerFrameHandler;