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

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_base = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;
_artyClass = "";
_gunnerClass = "";
_cleanup = [];

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPosTerrain);
};

if (_position isEqualTo []) exitWith {
    TASK_EXIT_DELAY(0);
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
    if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
        _artyClass = "B_MBT_01_arty_F";
    	_gunnerClass = "B_crew_F";
    };
};

// spawn base and find empty space for arty
_base = [_position,0.65 + random 1] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_bNodes = _base select 3;
_cleanup append (_base select 2);

_bNodes = _bNodes select {[_x select 0,ARTY_SIZE,0] call EFUNC(main,isPosSafe)};

if (_bNodes isEqualTo []) exitWith {
	(_base select 2) call EFUNC(main,cleanup);
	TASK_EXIT_DELAY(0);
};

_posArty = selectRandom _bNodes;
_posArty = _posArty select 0;

_arty = _artyClass createVehicle [0,0,0];
_arty setDir random 360;
_arty setPos _posArty;
_arty lock 2;
_arty allowCrewInImmobile true;
_cleanup pushBack _arty;

_grp = [_position,0,_strength,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength","_cleanup"];

		_cleanup append (units _grp);

        // regroup garrison units
        _garrisonGrp = createGroup EGVAR(main,enemySide);
        ((units _grp) select [0,TASK_GARRISONCOUNT]) joinSilent _garrisonGrp;
        [_garrisonGrp,_garrisonGrp,_bRadius,1,false] call CBA_fnc_taskDefend;

        // regroup patrols
        for "_i" from 0 to (count units _grp) - 1 step TASK_PATROL_UNITCOUNT do {
            _patrolGrp = createGroup EGVAR(main,enemySide);
            ((units _grp) select [0,TASK_PATROL_UNITCOUNT]) joinSilent _patrolGrp;
            [_patrolGrp, _patrolGrp, _bRadius, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] spawn CBA_fnc_taskPatrol;
        };
	},
	[_grp,_bRadius,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,_bRadius,_bRadius + 100,8,0] call EFUNC(main,findPosSafe);
_vehGrp = if !(_vehPos isEqualTo _position) then {
	[_vehPos,1,1,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY,true] call EFUNC(main,spawnGroup);
} else {
	[_vehPos,2,1,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
};

[
    {{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
    {
        params ["_position","_vehGrp","_bRadius","_cleanup"];

        _cleanup pushBack (objectParent leader _vehGrp);
        _cleanup pushBack (units _vehGrp);

        if (objectParent leader _vehGrp isKindOf "AIR") then {
            _waypoint = _vehGrp addWaypoint [_position,0];
            _waypoint setWaypointType "LOITER";
            _waypoint setWaypointLoiterRadius 700;
            _waypoint setWaypointLoiterType "CIRCLE";
            _waypoint setWaypointSpeed "NORMAL";
            _waypoint setWaypointBehaviour "AWARE";
        } else {
            [_vehGrp, _position, _bRadius*2, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] spawn CBA_fnc_taskPatrol;
        };
    },
    [_position,_vehGrp,_bRadius,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_tar = EGVAR(main,locations) select {!(CHECK_DIST2D(_x select 1,_posArty,(worldSize*0.04) max 1000))};

_tar = if !(_tar isEqualTo []) then {
	(selectRandom _tar) select 1;
} else {
    [_posArty,2000,8000] call EFUNC(main,findPosSafe);
};

_timerID = [
	3600,
	60,
    format ["%1 Countdown", TASK_NAME],
	{
		if (isServer) then {
            params ["time","_arty","_class","_tar"];

            _arty lock 3;
            _gunner = (createGroup EGVAR(main,enemySide)) createUnit [_class, [0,0,0], [], 0, "NONE"];
            _gunner assignAsGunner _arty;
            _gunner moveInGunner  _arty;
            _gunner disableAI "FSM";
            _gunner setBehaviour "CARELESS";
			_gunner doArtilleryFire [_tar, "32Rnd_155mm_Mo_shells", 4];
		};
	},
	[_arty,_gunnerClass,_tar]
] call EFUNC(main,setTimer);

// SET TASK
_taskDescription = "Enemy artillery forces are threatening to attack a local settlement that's sympathetic to our mission. To keep the local sentiment on our side, we're tasked with eliminating the artillery before it fires.";
[true,_taskID,[_taskDescription,TASK_TITLE,""], ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,true,"destroy"] call EFUNC(main,setTask);

TASK_DEBUG(_posArty);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_arty","_position","_cleanup","_timerID","_tar"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _arty) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_APPROVAL(_position,TASK_AV);
		TASK_EXIT;
	};

	if (EGVAR(main,timer) < 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
        TASK_APPROVAL(_tar,TASK_AV * -1);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_arty,_position,_cleanup,_timerID,_tar]] call CBA_fnc_addPerFrameHandler;
