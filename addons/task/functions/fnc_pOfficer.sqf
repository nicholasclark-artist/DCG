/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - kill officer

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define MRK_DIST 350
#define ENEMY_MINCOUNT 15

_position = [];
_classes = [];
_officer = objNull;

// CREATE TASK
_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findRuralPos);

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
_position = [_position,0,15,0.5] call EFUNC(main,findRandomPos);

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, _position, [], 0, "NONE"];
[[_officer]] call EFUNC(main,setPatrol);

// spawn enemy
_grp = [_position,0,ENEMY_MINCOUNT max (call EFUNC(main,setStrength)),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
[units _grp] call EFUNC(main,setPatrol);

if (CHECK_DEBUG) then {
	_mrk = createMarker [format ["vip_%1", diag_tickTime],getpos _officer];
	_mrk setMarkerColor format ["Color%1", EGVAR(main,enemySide)];
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText "Officer";
};

// SET TASK
_taskID = "pOfficer";
_taskText = "(P) Eliminate Officer";
_taskDescription = "A high ranking enemy officer has been spotted in the area. Find and eliminate the officer.";

[true,_taskID,[_taskDescription,_taskTitle,""],[_position,MRK_DIST*0.85,MRK_DIST] call EFUNC(main,findRandomPos),false,true,"Attack"] call EFUNC(main,setTask);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer"];

	_success = false;

	if (GVAR(primary) isEqualTo "") exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_vip call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		_vip call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	// if vip is returned to town and is alive/awake
	if (CHECK_DIST2D((_town select 1),_vip,RETURN_DIST)) then {
		if (CHECK_ADDON_1("ace_medical")) then {
			if ([_vip] call ace_common_fnc_isAwake) then {
				_success = true;
			};
		} else {
			if (alive _vip) then {
				_success = true;
			};
		};
	};

	if (_success) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		_vip call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};
}, HANDLER_SLEEP, [_taskID,_officer]] call CBA_fnc_addPerFrameHandler;