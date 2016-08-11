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
#define SUCCESS GVAR(DOUBLES(repair,success))
#define VEHCOUNT 2
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_drivers = [];
_vehicles = [];
SUCCESS = 0;

if (_position isEqualTo []) then {
	{
		_roads = (ASLToAGL _x) nearRoads 350;
		if !(_roads isEqualTo []) then {
			_temp = getPos (selectRandom _roads);
			if ((nearestLocations [_temp, ["NameCityCapital","NameCity","NameVillage"], (worldSize*0.04) max 500]) isEqualTo []) then {
				_position = _temp;
			};
		};
		if !(_position isEqualTo []) exitWith {};
	} forEach ([EGVAR(main,center),worldSize*0.04,worldSize] call EFUNC(main,findPosGrid));
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
				(vehicle _x) setDir random 360;
				[vehicle _x,QUOTE(SUCCESS = SUCCESS + 1)] call EFUNC(main,setVehDamaged);
				(crew (vehicle _x)) allowGetIn false;
				_grp leaveVehicle (vehicle _x);
			};
			false
		} count (units _grp);
	},
	[_grp,_drivers,_vehicles]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format["A friendly patrol, scouting near %1, is in need of repair supplies. Gather the necessary tools and assist the patrol.", mapGridPosition _position];

[true,_taskID,[_taskDescription,TASK_TITLE,""],ASLToAGL([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,true,"repair"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);
LOG_DEBUG_2("%1_%2",_drivers,_vehicles);
// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_drivers","_vehicles","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		[TASK_TYPE] call FUNC(select);
	};

	if ({!alive _x} count _vehicles > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV * -1);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		TASK_EXIT;
	};

	if (SUCCESS >= count _vehicles) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_drivers,_vehicles,_position]] call CBA_fnc_addPerFrameHandler;