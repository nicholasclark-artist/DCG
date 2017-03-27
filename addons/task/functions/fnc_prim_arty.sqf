/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - destroy artillery

Arguments:
0: forced task position <ARRAY>
1: forced base strength <NUMBER>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Destroy Artillery'
#define ARTY_SIZE 8
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_baseStrength",0.65 + random 1,[0]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_strength = TASK_STRENGTH + TASK_GARRISONCOUNT;
_vehGrp = grpNull;
_artyClass = "";
_gunnerClass = "";
_artyPool = [];
_cleanup = [];
_fnc_isArty = {
    (getNumber (configFile >> "CfgVehicles" >> _this >> "artilleryScanner")) > 0
};

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"meadow",10] call EFUNC(main,findPosTerrain);
};

if (_position isEqualTo []) exitWith {
    TASK_EXIT_DELAY(0);
};

call {
	if (EGVAR(main,enemySide) isEqualTo EAST) exitWith {
		_artyPool = EGVAR(main,artyPoolEast);
        _artyClass = "O_MBT_02_arty_F";
		_gunnerClass = selectRandom (EGVAR(main,unitPoolEast));
	};
	if (EGVAR(main,enemySide) isEqualTo RESISTANCE) exitWith {
		_artyPool = EGVAR(main,artyPoolInd);
        _artyClass = "B_T_MBT_01_arty_F";
        _gunnerClass = selectRandom (EGVAR(main,unitPoolInd));
	};
    if (EGVAR(main,enemySide) isEqualTo WEST) exitWith {
        _artyPool = EGVAR(main,artyPoolWest);
        _artyClass = "B_MBT_01_arty_F";
    	_gunnerClass = selectRandom (EGVAR(main,unitPoolWest));
    };
};

if !(_artyPool isEqualTo []) then {
    _temp = selectRandom _artyPool;
    if (_temp call _fnc_isArty) then {
        _artyClass = _temp;
    };
};

// spawn base and find empty space for arty
_base = [_position,_baseStrength] call EFUNC(main,spawnBase);
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
[_arty,AGLtoASL _posArty] call EFUNC(main,setPosSafe);
_arty lock 2;
_cleanup pushBack _arty;

_grp = [_position,0,_strength,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) >= (_this select 2)},
	{
        params ["_grp","_bRadius","_strength","_cleanup"];

		_cleanup append (units _grp);

        // regroup garrison units
        [
            _grp,
            TASK_GARRISONCOUNT,
            {[_this select 0,_this select 0,_this select 1,1,false] call CBA_fnc_taskDefend},
            [_bRadius],
            (count units _grp) - TASK_GARRISONCOUNT
        ] call EFUNC(main,splitGroup);

        // regroup patrols
        [
            _grp,
            TASK_PATROL_UNITCOUNT,
            {[_this select 0, _this select 0, _this select 1, 4, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [0,5,8]] call CBA_fnc_taskPatrol},
            [_bRadius],
            0,
            0.1
        ] call EFUNC(main,splitGroup);
	},
	[_grp,_bRadius,_strength,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_vehPos = [_position,_bRadius + 20,_bRadius + 150,8,0] call EFUNC(main,findPosSafe);
_vehGrp = if !(_vehPos isEqualTo _position) then {
	[_vehPos,1,1,EGVAR(main,enemySide),TASK_SPAWN_DELAY,true] call EFUNC(main,spawnGroup);
} else {
	[_vehPos,2,1,EGVAR(main,enemySide),TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
};

[
    {{_x getVariable [ISDRIVER,false]} count (units (_this select 1)) > 0},
    {
        params ["_position","_vehGrp","_bRadius","_cleanup"];

        _cleanup pushBack (objectParent leader _vehGrp);
        _cleanup append (units _vehGrp);

        if (objectParent leader _vehGrp isKindOf "AIR") then {
            _waypoint = _vehGrp addWaypoint [_position,0];
            _waypoint setWaypointType "LOITER";
            _waypoint setWaypointLoiterRadius 700;
            _waypoint setWaypointLoiterType "CIRCLE";
            _waypoint setWaypointSpeed "NORMAL";
            _waypoint setWaypointBehaviour "AWARE";
        } else {
            [_vehGrp, _position, _bRadius*2, 5, "MOVE", "SAFE", "YELLOW", "LIMITED", "STAG COLUMN", "", [5,10,15]] call CBA_fnc_taskPatrol;
        };
    },
    [_position,_vehGrp,_bRadius,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

_timerID = [
	3600,
	60,
    format ["%1 Countdown", TASK_NAME],
	{
		if (isServer) then {
            params ["_time","_arty","_class"];

            _arty lock 3;
            _gunner = (createGroup EGVAR(main,enemySide)) createUnit [_class, [0,0,0], [], 0, "NONE"];
            _gunner assignAsGunner _arty;
            _gunner moveInGunner  _arty;
            _gunner disableAI "FSM";
            _gunner setBehaviour "CARELESS";

            _arty addEventHandler ["Fired",{deleteVehicle (_this select 6)}];
            _pos = [getpos _arty,2000,2000] call EFUNC(main,findPosSafe);
            _gunner doArtilleryFire [_pos,(getArtilleryAmmo [_arty]) select 0,4];
		};
	},
	[_arty,_gunnerClass]
] call EFUNC(main,setTimer);

// SET TASK
_taskDescription = format ["%1 artillery forces are threatening to attack a local settlement that's sympathetic to our mission. We're tasked with eliminating the artillery before it fires.",[EGVAR(main,enemySide)] call BIS_fnc_sideName];
[true,_taskID,[_taskDescription,TASK_TITLE,""],ASLToAGL ([_position,TASK_DIST_MRK,TASK_DIST_MRK] call EFUNC(main,findPosSafe)),false,0,true,"destroy"] call BIS_fnc_taskCreate;

// PUBLISH TASK
_data = [_position,_baseStrength];
TASK_PUBLISH(_data);
TASK_DEBUG(_posArty);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_arty","_position","_cleanup","_timerID"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _arty) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_timerID] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
		TASK_APPROVAL(_position,TASK_AV);
		TASK_EXIT;
	};

	if (EGVAR(main,timer) < 1) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call BIS_fnc_taskSetState;
		_cleanup call EFUNC(main,cleanup);
        TASK_APPROVAL(_position,TASK_AV * -1);
		TASK_EXIT;
	};
}, TASK_SLEEP, [_taskID,_arty,_position,_cleanup,_timerID]] call CBA_fnc_addPerFrameHandler;
