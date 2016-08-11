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
#define TASK_NAME 'Find Intel'
#define INTEL_CLASS QUOTE(ItemGPS)
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_units = [];

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"forest",false] call EFUNC(main,findRuralPos);
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

_grp = createGroup CIVILIAN;
CACHE_DISABLE(_grp,true);

"Chemlight_green" createVehicle _position;
"Chemlight_green" createVehicle _position;

_leader = _grp createUnit [(selectRandom EGVAR(main,unitPoolCiv)), _position, [], 0, "NONE"];
_leader allowDamage false;
_leader disableAI "MOVE";
_leader setPosATL [_position select 0,_position select 1,30];
hideObjectGlobal _leader;

for "_i" from 1 to 10 do {
	_unit = _grp createUnit [(selectRandom EGVAR(main,unitPoolCiv)), _position, [], 5, "NONE"];
	_unit setDir random 360;
	removeFromRemainsCollector [_unit];
	_unit setDamage 1;
	_units pushBack _unit;
};

{
	removeAllItems _x;
	removeAllAssignedItems _x;
} forEach _units;

_unit = selectRandom _units;
_position = getpos _unit;
_unit linkItem INTEL_CLASS;

TASK_DEBUG(_position);

// SET TASK
_taskPos = ASLToAGL ([_position,70,100] call EFUNC(main,findPosSafe));
_taskDescription = format["A few days ago an informant didn't show for a meeting. He was suppose to hand off a GPS device with vital intel on the enemy's whereabouts. UAV reconnaissance spotted activity near %1. Search the site for the informant and retrieve the GPS.", mapGridPosition _position];

[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"search"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_unit","_grp"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(units _grp) call EFUNC(main,cleanup);
		[TASK_TYPE] call FUNC(select);
	};

	if !(INTEL_CLASS in (assignedItems _unit)) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos _unit,TASK_AV);
		(units _grp) call EFUNC(main,cleanup);
		TASK_EXIT;

		if (random 1 < 0.5) then {
			_posArray = [getpos _unit,50,400,300] call EFUNC(main,findPosGrid);
			{
				if !([_x,150] call EFUNC(main,getNearPlayers) isEqualTo []) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;

			if !(_posArray isEqualTo []) then {
				_grp = [selectRandom _posArray,0,[TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength),false,1] call EFUNC(main,spawnGroup);
				_wp = _grp addWaypoint [getposATL _unit,0];
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointFormation "STAG COLUMN";
				_cond = "!(behaviour this isEqualTo ""COMBAT"")";
				_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
			};
		};
	};
}, TASK_SLEEP, [_taskID,_unit,_grp]] call CBA_fnc_addPerFrameHandler;