/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - kill officer

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define MRK_DIST 350
#define ENEMY_MINCOUNT 12

private ["_classes","_officer","_base","_grp","_mrk","_taskPos","_taskID","_taskTitle","_taskDescription"];
params [["_position",[]]];

_classes = [];
_officer = objNull;

// CREATE TASK
if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findRuralPos);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_classes = EGVAR(main,officerPoolEast);
	};
	if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
		_classes = EGVAR(main,officerPoolWest);
	};
	_classes = EGVAR(main,officerPoolInd);
};

// exit if vars are empty
if (_position isEqualTo [] || {_classes isEqualTo []}) exitWith {
	[1,false] spawn FUNC(select);
};

// create base for officer
_base = [_position,random 1] call EFUNC(main,spawnBase);

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, _position, [], 0, "NONE"];
[[_officer],30] call EFUNC(main,setPatrol);

// spawn enemy
_grp = [_position,0,ENEMY_MINCOUNT max (call EFUNC(main,setStrength)),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
[units _grp,50] call EFUNC(main,setPatrol);

if (CHECK_DEBUG) then {
	_mrk = createMarker [format ["vip_%1", diag_tickTime],getpos _officer];
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText "Officer";
};

// SET TASK
_taskPos = [_position,MRK_DIST*0.85,MRK_DIST] call EFUNC(main,findRandomPos);
_taskID = format ["pOfficer_%1",diag_tickTime];
_taskTitle = "(P) Eliminate Officer";
_taskDescription = format ["A high ranking enemy officer has been spotted near %1. Find and eliminate the officer.",mapGridPosition _taskPos];

[true,_taskID,[_taskDescription,_taskTitle,""],_taskPos,false,true,"Attack"] call EFUNC(main,setTask);

// PUBLISH TASK
GVAR(primary) = [QFUNC(pOfficer),_position];
publicVariable QGVAR(primary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_grp","_base"];

	if (GVAR(primary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};
}, HANDLER_SLEEP, [_taskID,_officer,_grp,_base]] call CBA_fnc_addPerFrameHandler;