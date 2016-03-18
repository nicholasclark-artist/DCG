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
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define START_DIST 50
#define FAIL_DIST 500
#define COUNTDOWN 600
#define ENEMY_MAXCOUNT ([8,25] call EFUNC(main,setStrength))
#define END_TASK GVAR(primary) = []; publicVariable QGVAR(primary); [1] spawn FUNC(select);

private ["_enemies","_base","_type","_truck","_hitpoints","_driver","_grp","_taskID","_taskTitle","_taskDescription","_time","_wp","_vehPos"];
params [["_position",[]]];

_vehPos = [];
_enemies = [];
_base = [];
_type = "";

// CREATE TASK
if (_position isEqualTo []) then {
	if (isNull EGVAR(fob,location)) then {
		_position = [EGVAR(main,center),EGVAR(main,range),"house"] call EFUNC(main,findRuralPos);
		if !(_position isEqualTo []) then {
			_position = _position select 1;
		};
	} else {
		_position = locationPosition EGVAR(fob,location);
	};
};

if (_position isEqualTo []) exitWith {
	[1,0] spawn FUNC(select);
};

if !(isNull EGVAR(fob,location)) then {
	_base = [_position,0.7 + random 0.3] call EFUNC(main,spawnBase);
};

for "_i" from 1 to 100 do {
	_vehPos = [_position,0,30,6] call EFUNC(main,findRandomPos);
	if !(_vehPos isEqualTo _position) exitWith {};
};

if (_position isEqualTo _vehPos) exitWith {
	_base call EFUNC(main,cleanup);
	[1,0] spawn FUNC(select);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) then {
		_type = "O_Truck_03_ammo_F";
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) then {
		_type = "I_Truck_02_ammo_F";
	};
	_type = "B_Truck_01_ammo_F";
};

_truck = _type createVehicle _vehPos;
_truck lock 3;
_truck setDir random 360;
_hitpoints = [_truck] call EFUNC(main,setVehDamaged);
_truck allowDamage false;
_driver = (createGroup CIVILIAN) createUnit ["C_man_w_worker_F", [0,0,0], [], 0, "NONE"];
_driver moveInDriver _truck;
_driver allowFleeing 0;
_driver setBehaviour "CARELESS";
_driver setCombatMode "BLUE";
_driver disableAI "TARGET";
_driver disableAI "AUTOTARGET";
_truck allowCrewInImmobile true;

_grp = [_position,0,8,EGVAR(main,playerSide)] call EFUNC(main,spawnGroup);
[units _grp] call EFUNC(main,setPatrol);

// SET TASK
_taskID = format ["pDefend_%1",diag_tickTime];
_taskTitle = "(P) Defend Supplies";
_taskDescription = format ["A friendly supply unit is waiting for transport at %1. Move to the area and provide security until the transport arrives.", mapGridPosition _position];

[true,_taskID,[_taskDescription,_taskTitle,""],_position,false,true,"SUPPORT"] call EFUNC(main,setTask);

// PUBLISH TASK
GVAR(primary) = [QFUNC(pDefend),_position];
publicVariable QGVAR(primary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_truck","_hitpoints","_grp","_enemies","_base"];

	if (GVAR(primary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_truck] + _base) call EFUNC(main,cleanup);
		[1] spawn FUNC(select);
	};

	if ({CHECK_VECTORDIST(getPosASL _x,getPosASL _truck,START_DIST)} count allPlayers > 0) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[COUNTDOWN,60,"Defend Supplies","",call EFUNC(main,getPlayers)] call EFUNC(main,setTimer);

		[{
			params ["_args","_idPFH"];
			_args params ["_taskID","_truck","_hitpoints","_grp","_enemies","_base","_time"];

			if (GVAR(primary) isEqualTo []) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
				EGVAR(main,exitTimer) = true;
				((units _grp) + _enemies + [_truck] + _base) call EFUNC(main,cleanup);
				[1] spawn FUNC(select);
			};

			if ({CHECK_VECTORDIST(getPosASL _x,getPosASL _truck,FAIL_DIST)} count allPlayers isEqualTo 0) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				[_taskID, "FAILED"] call EFUNC(main,setTaskState);
				EGVAR(main,exitTimer) = true;
				((units _grp) + _enemies + [_truck] + _base) call EFUNC(main,cleanup);
				END_TASK
			};

			if (diag_tickTime > _time + COUNTDOWN) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
			  	{
			  		_truck setHit [getText (configFile >> "cfgVehicles" >> typeOf _truck >> "HitPoints" >> _x >> "name"), 0.25];
			  	} forEach _hitpoints;
			  	(group driver _truck) move [getPos (_this select 0),4000,5000] call EFUNC(main,findRandomPos);
				[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
				((units _grp) + _enemies + [_truck] + _base) call EFUNC(main,cleanup);
				END_TASK
			};

			{
				if (isNull _x) then {_enemies deleteAt _forEachIndex};
			} forEach _enemies;

			if (random 1 < 0.5 && {count _enemies < ENEMY_MAXCOUNT}) then {
				// TODO fix sleep error, runs in unscheduled environment for some reason
				_grp = [[getpos _truck,200,400] call EFUNC(main,findRandomPos),0,8,EGVAR(main,enemySide),false,0.5] call EFUNC(main,spawnGroup);
				_enemies append (units _grp);
				_wp = _grp addWaypoint [getpos _truck,30];
			};
			LOG_DEBUG_1("enemies %1", count _enemies);
		}, HANDLER_SLEEP, [_taskID,_truck,_hitpoints,_grp,_enemies,_base,diag_tickTime]] call CBA_fnc_addPerFrameHandler;
	};
}, HANDLER_SLEEP, [_taskID,_truck,_hitpoints,_grp,_enemies,_base]] call CBA_fnc_addPerFrameHandler;