/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - find intel 01

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Find GPS Intel'
#define INTEL_CLASS QUOTE(ItemGPS)
#define UNITCOUNT 5
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
GVAR(intel01Unit) = objNull;

if (_position isEqualTo []) then {
	if !(EGVAR(main,locals) isEqualTo []) then {
		_position = (selectRandom EGVAR(main,locals)) select 1;
		if !([_position,0.5,0] call EFUNC(main,isPosSafe)) then {
			_position = [];
		};
	} else {
		_position = [EGVAR(main,center),EGVAR(main,range),"forest",0,true] call EFUNC(main,findPos);
	};
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

if !([_position,5,0] call EFUNC(main,isPosSafe)) then {
	_position = [_position,5,50,1,0] call EFUNC(main,findPosSafe);
};

createVehicle ["Chemlight_green", ASLToAGL _position, [], 5, "NONE"];
createVehicle ["Chemlight_green", ASLToAGL _position, [], 5, "NONE"];

_grp = [_position,0,UNITCOUNT,CIVILIAN,true,0.5] call EFUNC(main,spawnGroup);

[
	{count units (_this select 1) >= UNITCOUNT},
	{
		params ["_position","_grp"];

		_units = units _grp - [leader _grp];
		(leader _grp) allowDamage false;
		(leader _grp) disableAI "MOVE";
		(leader _grp) setPosATL [_position select 0,_position select 1,30];
		(leader _grp) enableSimulation false;
		hideObjectGlobal (leader _grp);

		removeFromRemainsCollector units _grp;
		{
			_x setDir random 360;
			_x setDamage 1;
			removeAllItems _x;
			removeAllAssignedItems _x;
			false
		} count _units;

		_unit = selectRandom _units;
		_unit linkItem INTEL_CLASS;
		GVAR(intel01Unit) = _unit;
	},
	[_position,_grp]
] call CBA_fnc_waitUntilAndExecute;

TASK_DEBUG(_position);

// SET TASK
_taskPos = ASLToAGL ([_position,40,80] call EFUNC(main,findPosSafe));
_taskDescription = format["A few days ago an informant didn't show for a meeting. He was suppose to hand off a GPS device with vital intel on the enemy's whereabouts. Recently, UAV reconnaissance spotted activity near %1. Search the site for the informant and retrieve the GPS.", mapGridPosition _position];

[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"search"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_grp"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(units _grp) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(INTEL_CLASS in (assignedItems GVAR(intel01Unit))) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos GVAR(intel01Unit),TASK_AV);
		(units _grp) call EFUNC(main,cleanup);
		TASK_EXIT;

		if (random 1 < 0.5) then {
			_posArray = [getpos GVAR(intel01Unit),50,300,200] call EFUNC(main,findPosGrid);
			{
				if !([_x,150] call EFUNC(main,getNearPlayers) isEqualTo []) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;

			if !(_posArray isEqualTo []) then {
				_grp = [selectRandom _posArray,0,[TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
				_wp = _grp addWaypoint [getposATL GVAR(intel01Unit),0];
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointFormation "STAG COLUMN";
				_cond = "!(behaviour this isEqualTo ""COMBAT"")";
				_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
			};
		} else {
			[getpos GVAR(intel01Unit),EGVAR(main,enemySide),250] spawn EFUNC(main,spawnReinforcements);
		};
	};
}, TASK_SLEEP, [_taskID,_grp]] call CBA_fnc_addPerFrameHandler;