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
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define MRK_DIST 150

private ["_vehicles","_roads","_temp","_drivers","_taskID","_taskTitle","_taskDescription"];
params [["_position",[]]];

_vehicles = [];
GVAR(DOUBLES(sRepair,success)) = 0;

// CREATE TASK
if (_position isEqualTo []) then {
	{
		_roads = (ASLToAGL _x) nearRoads 350;
		if !(_roads isEqualTo []) then {
			_temp = getPos (selectRandom _roads);
			if ((nearestLocations [_temp, ["NameCityCapital","NameCity","NameVillage"], 1000]) isEqualTo []) then {
				_position = _temp;
			};
		};
		if !(_position isEqualTo []) exitWith {};
	} forEach ([EGVAR(main,center),2000,worldSize] call EFUNC(main,findPosGrid));
};

if (_position isEqualTo []) exitWith {
	[0,0] spawn FUNC(select);
};

_drivers = [_position,1,2,EGVAR(main,playerSide)] call EFUNC(main,spawnGroup);

{
	(crew (vehicle _x)) allowGetIn false;
	(group _x) leaveVehicle (vehicle _x);
	[vehicle _x,QUOTE(GVAR(DOUBLES(sRepair,success)) = GVAR(DOUBLES(sRepair,success)) + 1)] call EFUNC(main,setVehDamaged);
	_vehicles pushBack (vehicle _x);
} forEach _drivers;

// SET TASK
_taskID = format ["sRepair_%1",diag_tickTime];
_taskTitle = "(S) Repair Patrol";
_taskDescription = format["A friendly patrol, scouting near %1, is in need of repair supplies. Gather the necessary tools and assist the patrol.", mapGridPosition _position];

[true,_taskID,[_taskDescription,_taskTitle,""],[_position,MRK_DIST*0.5,MRK_DIST] call EFUNC(main,findRandomPos),false,true,"Support"] call EFUNC(main,setTask);

// PUBLISH TASK
GVAR(secondary) = [QFUNC(sRepair),_position];
publicVariable QGVAR(secondary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vehicles","_drivers"];

	if (GVAR(secondary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);
	};

	if ({!alive _x} count _vehicles > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);
	};

	if (GVAR(DOUBLES(sRepair,success)) isEqualTo count _vehicles) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		(_drivers + _vehicles) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);
	};
}, HANDLER_SLEEP, [_taskID,_vehicles,_drivers]] call CBA_fnc_addPerFrameHandler;