/*
Author:
Nicholas Clark (SENSEI)

Description:
deliver supplies to town

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [["_posArray",[]]];

_posConvoy = [];
_posDeliver = [];
_vehicles = [];
_type = "";
_grp = grpNull;

// CREATE TASK
if (count _posArray > 1) then {
	if ({CHECK_DIST2D(_x select 1,_posArray select 0,1000) && {CHECK_DIST2D(_x select 1,_posArray select 1,1000)}} count EGVAR(occupy,locations) isEqualTo 0) then {
		_posConvoy = _posArray select 0;
		_posDeliver = _posArray select 1;
	};
};

if (count (EGVAR(main,locations) > 1) && {_posConvoy isEqualTo []}) then {
	if (CHECK_ADDON_2(occupy)) then {
		if (count EGVAR(main,locations) >= (count EGVAR(occupy,locations)) + 2) then {
			_posConvoy = (selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations))})) select 1;
			_posDeliver = (selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations)) && !(_x isEqualTo _posConvoy)})) select 1;
		};
	} else {
		_posConvoy = (selectRandom EGVAR(main,locations)) select 1;
		_posDeliver = (selectRandom (EGVAR(main,locations) select {!(_x isEqualTo _posConvoy)})) select 1;
	};
}:

if (_posConvoy isEqualTo [] || {_posDeliver isEqualTo []}) exitWith {
	[0,0] spawn FUNC(select);
};

if (_posArray isEqualTo []) then {
	_roads = _posConvoy nearRoads 200;
	if !(_roads isEqualTo []) then {
		_posConvoy = getPos (selectRandom _roads);
		_posArray pushBack _posConvoy;
	};
	_roads = _posDeliver nearRoads 50;
	if !(_roads isEqualTo []) then {
		_posDeliver = getPos (selectRandom _roads);
		_posArray pushBack _posDeliver;
	};
};

if (count _posArray < 2) exitWith {
	[0,0] spawn FUNC(select);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) then {
		_type = "O_Truck_02_box_F"; side
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) then {
		_type = "I_Truck_02_box_F";
	};

	_type = "B_Truck_01_box_F";
};

// SET TASK
_taskID = format ["sDeliver_%1",diag_tickTime];
_taskTitle = "(S) Deliver Supplies";
_taskDescription = format["A convoy enroute to deliver medical supplies to %1 broke down somewhere around %2. Repair the convoy and complete the delivery.",_town select 0,mapGridPosition _position];

// PUBLISH TASK
GVAR(primary) = [QFUNC(sDeliver),_position];
publicVariable QGVAR(primary);

// TASK HANDLER

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