/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - destroy artillery

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Destroy Artillery'
#define ARTY_SIZE 8
#include "script_component.hpp"

params [["_position",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_base = [];
_strength = [TASK_UNIT_MIN,TASK_UNIT_MAX] call EFUNC(main,setStrength);
_vehGrp = grpNull;
_artyClass = "";
_gunnerClass = "";
_objs = [];

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPos);
};

if (_position isEqualTo []) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_artyClass = "O_MBT_02_arty_F";
		_gunnerClass = "O_crew_F";
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_artyClass = "B_MBT_01_arty_F";
		_gunnerClass = "I_crew_F";
	};
	_artyClass = "B_MBT_01_arty_F";
	_gunnerClass = "B_crew_F";
};

_base = [_position,0.65 + random 1] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_bNodes = _base select 3;
_objs append (_base select 2);

_bNodes = _bNodes select {(_x select 1) >= ARTY_SIZE && {[_x select 0,ARTY_SIZE,0] call EFUNC(main,isPosSafe)}};

if (_bNodes isEqualTo []) exitWith {
	(_base select 2) call EFUNC(main,cleanup);
	[TASK_TYPE,0] call FUNC(select);
};

_posArty = selectRandom _bNodes;
_posArty = _posArty select 0;

_arty = _artyClass createVehicle [0,0,0];
_arty setDir random 360;
_arty setPos _posArty;
_arty lock 3;
_arty allowCrewInImmobile true;
_objs pushBack _arty;

_gunner = (createGroup EGVAR(main,enemySide)) createUnit [_gunnerClass, [0,0,0], [], 0, "NONE"];
_gunner assignAsGunner _arty;
_gunner moveInGunner  _arty;
_gunner setFormDir (getDir _arty);
_gunner setDir (getDir _arty);
_gunner disableAI "FSM";
_gunner disableAI "MOVE";
_objs pushBack _gunner;

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,2] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
		[units (_this select 0),_this select 1] call EFUNC(main,setPatrol);
		(_this select 3) append (units (_this select 0));
		(_this select 4) doWatch ((_this select 4) modelToWorld [0,50,50]);
	},
	[_grp,_bRadius,_strength,_objs,_gunner]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,100,200,8,0] call EFUNC(main,findPosSafe);

if !(_vehPos isEqualTo _position) then {
	_vehGrp = [_vehPos,1,1,EGVAR(main,enemySide),false,1,true] call EFUNC(main,spawnGroup);

	[
		{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
		{
			[units (_this select 0),((_this select 1)*4 min 300) max 100] call EFUNC(main,setPatrol);
			(_this select 2) append (units (_this select 0));
		},
		[_vehGrp,_bRadius,_objs]
	] call CBA_fnc_waitUntilAndExecute;
} else {
	_vehGrp = [_vehPos,2,1,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);
	[
		{{_x getVariable [QUOTE(EGVAR(main,spawnDriver)),false]} count (units (_this select 0)) > 0},
		{
			[units (_this select 0),1200] call EFUNC(main,setPatrol);
		},
		[_vehGrp,_bRadius]
	] call CBA_fnc_waitUntilAndExecute;
};

_tar = EGVAR(main,locations) select {!(CHECK_DIST2D(_x select 1,_posArty,(worldSize*0.04) max 1000))};

if !(_tar isEqualTo []) then {
	_tar = (selectRandom _tar) select 1;
} else {
	_tar = [_posArty,4000,8000] call EFUNC(main,findPosSafe);
};

_timerID = [
	3600,
	60,
	"Artillery Countdown",
	{
		if (isServer) then {
			(_this select 1) doArtilleryFire [(_this select 2), "32Rnd_155mm_Mo_shells", 4];
		};
	},
	[_gunner,_tar]
] call EFUNC(main,setTimer);

// SET TASK
_taskDescription = format ["An enemy FOB housing an artillery unit is targetting a local settlement that's sympathetic to our cause. To keep the civilian's on our side, we must elminate the artillery."];
[true,_taskID,[_taskDescription,TASK_TITLE,""], ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,true,"destroy"] call EFUNC(main,setTask);

TASK_DEBUG(_posArty);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_arty","_vehGrp","_position","_objs","_timerID"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		(_objs + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(alive _arty) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		(_objs + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		TASK_APPROVAL(_position,TASK_AV);
		TASK_EXIT;
	};

	if (EGVAR(main,timer) < 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		(_objs + [vehicle leader _vehGrp]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_arty,_vehGrp,_position,_objs,_timerID]] call CBA_fnc_addPerFrameHandler;