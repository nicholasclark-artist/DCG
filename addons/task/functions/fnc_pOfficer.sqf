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

private ["_drivers","_classes","_officer","_base","_grp","_vehPos","_mrk","_taskPos","_taskID","_taskTitle","_taskDescription"];
params [["_position",[]]];

_drivers = [];
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
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_classes = EGVAR(main,officerPoolInd);
	};
};

if (_position isEqualTo [] || {_classes isEqualTo []}) exitWith {
	[1,0] spawn FUNC(select);
};

_base = [_position,0.4 + random 0.6] call EFUNC(main,spawnBase);

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, _position, [], 0, "NONE"];
[[_officer],20] call EFUNC(main,setPatrol);

_grp = [_position,0,[PMIN,PMAX] call EFUNC(main,setStrength),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
[units _grp,50] call EFUNC(main,setPatrol);

if (random 1 < 0.5) then {
	_vehPos = [_position,0,200,6] call EFUNC(main,findRandomPos);
	if !(_vehPos isEqualTo _position) then {
		_drivers = [_vehPos,1,1,EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
		[_drivers,300] call EFUNC(main,setPatrol);
	};
};

if (CHECK_DEBUG) then {
	_mrk = createMarker [format ["officer_%1", diag_tickTime],getpos _officer];
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText "Officer";
};

// SET TASK
_taskPos = ASLToAGL ([_position,MRK_DIST,MRK_DIST] call EFUNC(main,findRandomPos));
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
	_args params ["_taskID","_officer","_grp","_drivers","_base"];

	if (GVAR(primary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base + _drivers) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		((units _grp) + [_officer] + _base + _drivers) call EFUNC(main,cleanup);
		ENDP
	};
}, HANDLER_SLEEP, [_taskID,_officer,_grp,_drivers,_base]] call CBA_fnc_addPerFrameHandler;