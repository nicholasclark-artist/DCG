/*
Author:
Nicholas Clark (SENSEI)

Description:
primary task - defend supplies

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_PRIMARY
#define TASK_NAME 'Defend Supplies'
#define COUNTDOWN 600
#define FRIENDLY_COUNT 4
#define ENEMY_COUNT 8
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_type = "";
_vehPos = [];
_cleanup = [];
GVAR(defend_enemies) = [];

if (_position isEqualTo []) then {
	_position = [EGVAR(main,center),EGVAR(main,range),"house",0,true] call EFUNC(main,findPosTerrain);
	if !(_position isEqualTo []) then {
		_position = _position select 1;
	};
};

if (_position isEqualTo []) exitWith {
	TASK_EXIT_DELAY(0);
};

for "_i" from 1 to 100 do {
	_vehPos = [_position,0,25,16,0,.35] call EFUNC(main,findPosSafe);
	if !(_vehPos isEqualTo _position) exitWith {};
};

if (_vehPos isEqualTo _position) exitWith {
	TASK_EXIT_DELAY(0);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_type = "O_Truck_03_ammo_F";
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) exitWith {
		_type = "I_Truck_02_ammo_F";
	};
    if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
        _type = "B_Truck_01_ammo_F";
    };
};

_truck = _type createVehicle [0,0,0];
_truck lock 3;
_truck setFuel 0;
[_truck,_vehPos] call EFUNC(main,setPosSafe);
_truck allowDamage false;
_cleanup pushBack _truck;

_driver = (createGroup CIVILIAN) createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];
_driver moveInDriver _truck;
_driver setBehaviour "CARELESS";
_driver setCombatMode "BLUE";
_driver disableAI "FSM";

_grp = [_position,0,FRIENDLY_COUNT,EGVAR(main,playerSide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
_cleanup append (units _grp);

// SET TASK
_taskDescription = "A friendly unit is resupplying beyond the safezone. Move to the area and provide security while the vehicle is idle.";
[true,_taskID,[_taskDescription,TASK_TITLE,""],_position,false,true,"defend"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_position);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_truck","_cleanup"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(([getPos _truck,TASK_DIST_START] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		_timerID = [COUNTDOWN,60,TASK_NAME] call EFUNC(main,setTimer);

		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_truck","_cleanup","_enemyCount","_timerID"];

			if (TASK_GVAR isEqualTo []) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_timerID] call CBA_fnc_removePerFrameHandler;
				[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
				(_cleanup + GVAR(defend_enemies)) call EFUNC(main,cleanup);
				TASK_EXIT_DELAY(30);
			};

			if (([getPos _truck,TASK_DIST_FAIL] call EFUNC(main,getNearPlayers)) isEqualTo []) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_timerID] call CBA_fnc_removePerFrameHandler;
				[_taskID, "FAILED"] call EFUNC(main,setTaskState);
				(_cleanup + GVAR(defend_enemies)) call EFUNC(main,cleanup);
				TASK_APPROVAL(getPos _truck,TASK_AV * -1);
				TASK_EXIT;
			};

			if (EGVAR(main,timer) < 1) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
				(_cleanup + GVAR(defend_enemies)) call EFUNC(main,cleanup);
				TASK_APPROVAL(getPos _truck,TASK_AV);
				TASK_EXIT;

                _pos = [getPos _truck,3000,4000] call EFUNC(main,findPosSafe);
                _truck setFuel 1;
                _wp = (group driver _truck) addWaypoint [_pos, 0];
                _wp setWaypointSpeed "NORMAL";
                _wp setWaypointBehaviour "CARELESS";
			};

			GVAR(defend_enemies) = GVAR(defend_enemies) select {!(isNull _x)};

			if (random 1 < 0.2 && {count GVAR(defend_enemies) < _enemyCount}) then {
				_grp = [[getpos _truck,200,400] call EFUNC(main,findPosSafe),0,ENEMY_COUNT,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
				[
					{count units (_this select 0) >= ENEMY_COUNT},
					{
						GVAR(defend_enemies) append (units (_this select 0));
						[_this select 0, getpos (_this select 1), 100] call CBA_fnc_taskAttack;
					},
					[_grp,_truck]
				] call CBA_fnc_waitUntilAndExecute;
			};
		}, TASK_SLEEP, [_taskID,_truck,_cleanup,TASK_STRENGTH,_timerID]] call CBA_fnc_addPerFrameHandler;
	};
}, TASK_SLEEP, [_taskID,_truck,_cleanup]] call CBA_fnc_addPerFrameHandler;
