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
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define MRK_DIST 350
#define RETURN_DIST 20
#define ENEMY_MINCOUNT 8
#define ENEMY_MAXCOUNT 20

private ["_drivers","_town","_base","_grp","_vip","_taskID","_taskTitle","_taskDescription","_taskPos","_mrk","_success"];
params [["_position",[]]];

_drivers = [];
_town = [];
_base = [];
_grp = grpNull;
_vip = objNull;

// CREATE TASK
if (_position isEqualTo []) then {
	if (toLower worldName in EGVAR(main,simpleWorlds)) then {
		_position = [EGVAR(main,center),EGVAR(main,range),"meadow"] call EFUNC(main,findRuralPos);
	} else {
		_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findRuralPos);
		if !(_position isEqualTo []) then {
			_position = (_position select 1);
		};
	};
};

// find return location
if !(EGVAR(main,locations) isEqualTo []) then {
	if (CHECK_ADDON_2(occupy)) then {
		if (count EGVAR(main,locations) > count EGVAR(occupy,locations)) then {
			_town = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations))});
		};
	} else {
		_town = selectRandom EGVAR(main,locations);
	};
};

if (_position isEqualTo [] || {_town isEqualTo []}) exitWith {
	[1,0] spawn FUNC(select);
};

if (toLower worldName in EGVAR(main,simpleWorlds)) then {
	_base = [_position,random 0.6] call EFUNC(main,spawnBase);
	_position = [_position,0,15,0.5] call EFUNC(main,findRandomPos);
};

_vip = (createGroup civilian) createUnit ["C_Nikos", _position, [], 0, "NONE"];
_vip setDir random 360;
_vip setPosATL _position;
[_vip,"Acts_AidlPsitMstpSsurWnonDnon02"] call EFUNC(main,setAnim);

_grp = [_position,0,[ENEMY_MINCOUNT,ENEMY_MAXCOUNT] call EFUNC(main,setStrength),EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
[units _grp] call EFUNC(main,setPatrol);

if (random 1 < 0.5) then {
	_drivers = [[_position,0,200,6] call EFUNC(main,findRandomPos),1,1,EGVAR(main,enemySide)] call EFUNC(main,spawnGroup);
	[_drivers,500] call EFUNC(main,setPatrol);
};

// SET TASK
_taskPos = [_position,MRK_DIST*0.85,MRK_DIST] call EFUNC(main,findRandomPos);
_taskID = format ["pVIP_%1",diag_tickTime];
_taskTitle = "(P) Rescue VIP";
_taskDescription = format ["We have intel that the son of a local elder has been taken hostage by enemy forces somewhere near %1. Locate the VIP, %2, and safely escort him to %3.",mapGridPosition _taskPos, name _vip, _town select 0];

[true,_taskID,[_taskDescription,_taskTitle,""],_taskPos,false,true,"Search"] call EFUNC(main,setTask);

if (CHECK_DEBUG) then {
	_mrk = createMarker [format ["vip_%1", diag_tickTime],getpos _vip];
	_mrk setMarkerColor "ColorCIV";
	_mrk setMarkerType "mil_dot";
	_mrk setMarkerText "VIP";
};

// PUBLISH TASK
GVAR(primary) = [QFUNC(pVip),_position];
publicVariable QGVAR(primary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_vip","_grp","_drivers","_town","_base"];

	_success = false;

	if (GVAR(primary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + _drivers + [_vip] + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if !(alive _vip) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		((units _grp) + _drivers + [_vip] + _base) call EFUNC(main,cleanup);
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
		((units _grp) + _drivers + [_vip] + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};
}, HANDLER_SLEEP, [_taskID,_vip,_grp,_drivers,_town,_base]] call CBA_fnc_addPerFrameHandler;