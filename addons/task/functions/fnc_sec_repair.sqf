/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - repair vehicles

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Repair Patrol'
#define VEHCOUNT 2
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_drivers = [];
_vehicles = [];

if (_position isEqualTo []) then {
	{
		_roads = (ASLToAGL _x) nearRoads 350;
		if !(_roads isEqualTo []) exitWith {
			_position = getPos (selectRandom _roads);
		};
	} forEach ([EGVAR(main,center),worldSize*0.04,worldSize] call EFUNC(main,findPosGrid));
};

if (CHECK_ADDON_2(occupy)) then {
	if ({CHECK_DIST2D(_x select 1,_position,1000)} count EGVAR(occupy,locations) > 0) then {
		_position = [];
	};
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

_grp = [_position,1,VEHCOUNT,EGVAR(main,playerSide),false,1] call EFUNC(main,spawnGroup);

[
	{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) >= VEHCOUNT},
	{
		_this params ["_grp","_drivers","_vehicles"];

		{
			if (_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]) then {
				_drivers pushBack _x;
				_vehicles pushBack (vehicle _x);
				_x removeItems "ToolKit";
				(vehicle _x) setDir random 360;
				(vehicle _x) lock 3;
				[vehicle _x,2,{(_this select 0) setVariable [TASK_QFUNC,true]}] call EFUNC(main,setVehDamaged);
				(crew (vehicle _x)) allowGetIn false;
				_grp leaveVehicle (vehicle _x);

			};
			false
		} count (units _grp);
	},
	[_grp,_drivers,_vehicles]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format["A friendly patrol, scouting near %1, is in need of repairs. Gather the necessary tools and assist the patrol.", mapGridPosition _position];

[true,_taskID,[_taskDescription,TASK_TITLE,""],ASLToAGL([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,true,"repair"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_drivers","_vehicles","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if ({!alive _x} count _vehicles > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV * -1);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		TASK_EXIT;
	};

	if ({_x getVariable [TASK_QFUNC,false]} count _vehicles isEqualTo VEHCOUNT) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_drivers,_vehicles,_position]] call CBA_fnc_addPerFrameHandler;