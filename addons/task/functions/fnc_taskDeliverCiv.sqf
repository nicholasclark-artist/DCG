/*
Author: Nicholas Clark (SENSEI)

Description:
deliver supplies to town

Arguments:

Return:
none
__________________________________________________________________*/
if !(isServer) exitWith {};

#include "script_component.hpp"

private ["_town","_taskID","_taskText","_taskDescription","_count","_aidArray","_pos","_aid","_halfway","_posAid","_iedPos","_type","_grp","_wp","_veh","_hitpoints","_fx","_bonus"];

_town = DCG_locations select floor (random (count DCG_locations));
_taskID = format["%1_deliver_civ",DCG_taskCounterCiv];
_taskText = "Deliver Supplies";
_taskDescription = format["The enemy occupation has left the locals in distress. The townspeople of %1 (%2) desparately need medical supplies.<br/><br/>Collect the supplies from the MOB Depot and deliver them to %1.",_town select 0,mapGridPosition (_town select 1)];

_count = 3;
_aidArray = [];
_pos = [_town select 1,0,50] call DCG_fnc_findRandomPos;

for "_i" from 1 to _count do {
	_aid = "ACE_medicalSupplyCrate_advanced" createVehicle (getMarkerPos "DCG_depotSpawn_mrk");
	_aid setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.9,0.05,0.05,1)"];
	_aid setVariable ["DCG_noClean", true, true];
	_aidArray pushBack _aid;
};
_halfway = ((_aidArray select 0) distance2D _pos)/2;

TASKWPOS(_taskID,_taskDescription,_taskText,_pos,"C")

[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_pos","_halfway","_aidArray","_count"];

	if ({!alive _x} count _aidArray > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		_aidArray call DCG_fnc_cleanup;
		call DCG_fnc_setTaskCiv;
	};
	if ((_aidArray select 0) distance2D _pos < _halfway) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_posAid = getPosATL (_aidArray select 0);
		_posAid set [2,0];
		if (random 1 < 0.20) then {
			private "_veh";
			{
				if ((_aidArray select 0) in ((vehicle _x) getVariable ["ace_cargo_loaded",[]])) exitWith {
					_veh = vehicle _x;
				};
			} forEach allPlayers;

			if !(isNil "_veh") then {
				[_veh] call DCG_fnc_setVehDamaged;
				_grp = [[_posAid,250,300] call DCG_fnc_findRandomPos,0,STRENGTH(8,15)] call DCG_fnc_spawnGroup;
				SAD(_grp,(_aidArray select 0))
			};
		};
		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_pos","_aidArray","_count"];

			if ({!alive _x} count _aidArray > 0) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "FAILED"] call BIS_fnc_taskSetState;
				_aidArray call DCG_fnc_cleanup;
				call DCG_fnc_setTaskCiv;
			};
			if ({(getPosATL _x) distance _pos < MINDIST} count _aidArray isEqualTo _count) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				if (random 1 < 0.70) then {[_pos,DCG_enemySide] call DCG_fnc_spawnReinforcements};
				[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
				_bonus = round (35 + random 20);
				DCG_approval = DCG_approval + _bonus;
				publicVariable "DCG_approval";
				["DCG_approvalBonus",[_bonus,'Assisting the local population has increased your approval!']] remoteExecCall ["BIS_fnc_showNotification", allPlayers, false];
				_aidArray call DCG_fnc_cleanup;
				call DCG_fnc_setTaskCiv;
			};
		}, 5, [_taskID,_pos,_aidArray,_count]] call CBA_fnc_addPerFrameHandler;
	};
}, 5, [_taskID,_pos,_halfway,_aidArray,_count]] call CBA_fnc_addPerFrameHandler;