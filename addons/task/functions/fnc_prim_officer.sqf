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
#define TASK_PRIMARY
#define TASK_NAME 'Eliminate Officer'
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_classes = [];
_cleanup = [];
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPosTerrain);
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

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

_base = [_position,0.65 + random 1] call EFUNC(main,spawnBase);
_bRadius = _base select 0;
_cleanup append (_base select 2);

_officer = (createGroup EGVAR(main,enemySide)) createUnit [selectRandom _classes, ASLtoAGL _position, [], 0, "NONE"];
_cleanup pushBack _officer;
[group _officer,_position,_bRadius*0.5,1,false] call CBA_fnc_taskDefend;

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

TASK_DEBUG(getPos _officer);

// SET TASK
_taskPos = ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe));
_taskDescription = "A high ranking enemy officer has been spotted nearby. Find and eliminate the officer.";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_taskPos,false,true,"kill"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_officer","_cleanup","_position"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _officer) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(_position,TASK_AV);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_officer,_cleanup,_position]] call CBA_fnc_addPerFrameHandler;
