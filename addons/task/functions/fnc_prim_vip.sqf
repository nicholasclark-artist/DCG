/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - rescue VIP

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Rescue VIP'
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_drivers = [];
_town = [];
_base = [];
_strength = [TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength);
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	if (toLower worldName in EGVAR(main,simpleWorlds)) then {
		_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findPosRural);
	} else {
		_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findPosRural);
		if !(_position isEqualTo []) then {
			_position = (_position select 1);
		};
	};
};

// find return location
if !(EGVAR(main,locations) isEqualTo []) then {
	if (CHECK_ADDON_2(occupy)) then {
		_town = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations))});
	} else {
		_town = selectRandom EGVAR(main,locations);
	};
};

// cannot move vip without ACE captives addon
// TODO add vanilla compatible version
if (_position isEqualTo [] || {_town isEqualTo []} || {!(CHECK_ADDON_1("ace_captives"))}) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

if (toLower worldName in EGVAR(main,simpleWorlds)) then {
	_base = [_position,0.6 + random 1] call EFUNC(main,spawnBase);
	if !((_base select 3) isEqualTo []) then {
		_position = selectRandom (_base select 3);
		_position = _position select 0;
	} else {
		_position = [_position,0,15,0.5,0] call EFUNC(main,findPosSafe);
	};
};

_vip = (createGroup civilian) createUnit ["C_Nikos", [0,0,0], [], 0, "NONE"];
_vip setDir random 360;
_vip setPosASL _position;
[_vip,"Acts_AidlPsitMstpSsurWnonDnon02",true] call EFUNC(main,setAnim);

_grp = [[_position,10,20] call EFUNC(main,findPosSafe),0,_strength,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 1)},
	{
		[units (_this select 0)] call EFUNC(main,setPatrol);
	},
	[_grp,_strength]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,50,100,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
		{
			[units (_this select 0),200] call EFUNC(main,setPatrol);
		},
		[_vehGrp]
	] call CBA_fnc_waitUntilAndExecute;
};

if !(_base isEqualTo []) then {
	_base = _base select 2;
};

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = format ["We have intel that the son of a local elder has been taken hostage by enemy forces somewhere near %1. Locate the VIP, %2, and safely escort him to %3.",mapGridPosition _taskPos, name _vip, _town select 0];

[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"Search"] call EFUNC(main,setTask);

TASK_DEBUG(getpos _vip);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vip","_grp","_vehGrp","_town","_base"];

	_success = false;

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + (units _vehGrp) + [_vip] + _base + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL((getPos _vip),TASK_AV * -1);
		((units _grp) + (units _vehGrp) + [_vip] + _base + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};

	// if vip is returned to town and is alive/awake
	if (CHECK_DIST2D((_town select 1),_vip,TASK_DIST_RET)) then {
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
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL((getPos _vip),TASK_AV);
		((units _grp) + (units _vehGrp) + [_vip] + _base + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_vip,_grp,_vehGrp,_town,_base]] call CBA_fnc_addPerFrameHandler;