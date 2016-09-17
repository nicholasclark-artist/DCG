/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - find intel 02

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Find Map Intel'
#define INTEL_CLASS QUOTE(ItemMap)
#define UNITCOUNT 6
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_vehicle = objNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"house",false] call EFUNC(main,findPosRural);
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_classes = EGVAR(main,vehPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_classes = EGVAR(main,vehPoolWest);
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_classes = EGVAR(main,vehPoolInd);
	};
};

_position = _position select 1;
_vehPos = [_position,5,30,7,0] call EFUNC(main,findPosSafe);

if !(_position isEqualTo _vehPos) then {
	_vehicle = (selectRandom _classes) createVehicle [0,0,0];
	[_vehicle] call EFUNC(main,setPosSafe);
};

_grp = [_position,0,UNITCOUNT,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= UNITCOUNT},
	{
		_this params ["_grp"];

		[units _grp,20] call EFUNC(main,setPatrol);

		{
			removeAllAssignedItems _x;
			removeHeadgear _x;
			removeVest _x;
		} forEach (units _grp);

		(leader _grp) linkItem INTEL_CLASS;
	},
	[_grp]
] call CBA_fnc_waitUntilAndExecute;

TASK_DEBUG(_position);

// SET TASK
_taskDescription = format["Aerial reconnaissance spotted an enemy fireteam at %1. This is an opportunity to gain the upper hand. Ambush the unit and search the enemy combatants for intel.", mapGridPosition _position];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_position,false,true,"search"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_grp","_vehicle"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_vehicle]) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(INTEL_CLASS in (assignedItems (leader _grp))) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos (leader _grp),TASK_AV);
		((units _grp) + [_vehicle]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_grp,_vehicle]] call CBA_fnc_addPerFrameHandler;