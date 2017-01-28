/*
Author:
Nicholas Clark (SENSEI)

Description:
secondary task - deliver supplies

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#define TASK_SECONDARY
#define TASK_NAME 'Deliver Supplies'
#define UNITCOUNT 4
#include "script_component.hpp"

params [
    ["_positions",[],[[]]]
];

// CREATE TASK
_taskID = str diag_tickTime;
_cleanup = [];
_type = "";
_locationStart = [];
_locationEnd = [];
_positionStart = [];
_positionEnd = [];

if (count _positions > 1) then {
	_locationStart = _positions select 0;
	_locationEnd = _positions select 1;
};

if (count EGVAR(main,locations) > 1 && {_positions isEqualTo []}) then {
	if (CHECK_ADDON_2(occupy)) then {
		if (count EGVAR(main,locations) >= (count EGVAR(occupy,locations)) + 2) then {
			_locationStart = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations))});
			_locationEnd = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations)) && !(COMPARE_STR(_x select 0,_locationStart select 0))});
		};
	} else {
		_locationStart = selectRandom EGVAR(main,locations);
		_locationEnd = selectRandom (EGVAR(main,locations) select {!(COMPARE_STR(_x select 0,_locationStart select 0))});
	};

    if (!(_locationStart isEqualTo []) && {!(_locationEnd isEqualTo [])}) then {
        _positions pushBack _locationStart;
        _positions pushBack _locationEnd;
    };
};

if (count _positions < 2) exitWith {
	TASK_EXIT_DELAY(0);
};

_positionStart = [_locationStart select 1,0,(_locationStart select 2) + 50,8,0,0.5] call EFUNC(main,findPosSafe);
_positionEnd = [_locationEnd select 1,0,_locationEnd select 2] call EFUNC(main,findPosSafe);

if (_positionStart isEqualTo [] || {_positionEnd isEqualTo []}) exitWith {
	TASK_EXIT_DELAY(0);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_type = "O_Truck_02_box_F";
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) exitWith {
		_type = "I_Truck_02_box_F";
	};
    if (EGVAR(main,playerSide) isEqualTo WEST) exitWith {
		_type = "B_Truck_01_box_F";
	};
};

_veh = _type createVehicle [0,0,0];
_veh setDir random 360;
_veh setPos _positionStart;
_veh setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.27,0.27,0.27,1)"];
[_veh] call EFUNC(main,setVehDamaged);
_cleanup pushBack _veh;

if (CHECK_ADDON_1("ace_cargo")) then {
	_cargo = if (CHECK_ADDON_1("ace_medical")) then {
		"ACE_medicalSupplyCrate_advanced";
	} else {
		"Medikit";
	};
	for "_i" from 1 to 5 do {
		[_cargo, _veh] call ace_cargo_fnc_loadItem;
	};
} else {
	clearWeaponCargoGlobal _veh;
	clearMagazineCargoGlobal _veh;
	clearItemCargoGlobal _veh;
	_veh addItemCargoGlobal ["Medikit", 5];
};

_grp = [_positionStart,0,UNITCOUNT,EGVAR(main,playerSide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) isEqualTo UNITCOUNT},
	{
        params ["_grp","_cleanup"];

        _cleanup append (units _grp);
	},
	[_grp,_cleanup]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format["A convoy enroute to deliver medical supplies to %1 broke down somewhere near %2. Repair the convoy and complete the delivery to %1.",_locationEnd select 0, _locationStart select 0];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_positionStart,false,true,"run"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_positions);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_positionEnd","_veh","_cleanup"];

	if (TASK_GVAR isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT_DELAY(30);
	};

	if !(alive _veh) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos _veh,TASK_AV * -1);
		_cleanup call EFUNC(main,cleanup);
		TASK_EXIT;
	};

    if (speed _veh > 1) then {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [_taskID,_positionEnd] call BIS_fnc_taskSetDestination;

        [{
            params ["_args","_idPFH"];
            _args params ["_taskID","_positionEnd","_veh","_cleanup"];

            if (TASK_GVAR isEqualTo []) exitWith {
        		[_idPFH] call CBA_fnc_removePerFrameHandler;
        		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
        		_cleanup call EFUNC(main,cleanup);
        		TASK_EXIT_DELAY(30);
        	};

            if !(alive _veh) exitWith {
        		[_idPFH] call CBA_fnc_removePerFrameHandler;
        		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
        		TASK_APPROVAL(getPos _veh,TASK_AV * -1);
        		_cleanup call EFUNC(main,cleanup);
        		TASK_EXIT;
        	};

            if ((_veh inArea [_positionEnd,TASK_DIST_RET,TASK_DIST_RET,0,false,10]) && {speed _veh < 1}) exitWith {
        		[_idPFH] call CBA_fnc_removePerFrameHandler;
        		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
        		TASK_APPROVAL(getPos _veh,TASK_AV);
        		_cleanup call EFUNC(main,cleanup);
        		TASK_EXIT;

        		if (random 1 < 0.5) then {
        			_posArray = [getpos _veh,64,400,300] call EFUNC(main,findPosGrid);
        			{
        				if !([_x,100] call EFUNC(main,getNearPlayers) isEqualTo []) then {
        					_posArray deleteAt _forEachIndex;
        				};
        			} forEach _posArray;

        			if !(_posArray isEqualTo []) then {
        				_grp = [selectRandom _posArray,0,TASK_STRENGTH,EGVAR(main,enemySide),false,TASK_SPAWN_DELAY] call EFUNC(main,spawnGroup);
        				_wp = _grp addWaypoint [getposATL _veh,0];
                        _grp setCombatMode "RED";
        				_wp setWaypointType "SAD";
        				_cond = "!(behaviour this isEqualTo ""COMBAT"")";
        				_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
        			};
        		} else {
        			[getpos _veh,EGVAR(main,enemySide)] spawn EFUNC(main,spawnReinforcements);
        		};
        	};
        }, TASK_SLEEP, [_taskID,_positionEnd,_veh,_cleanup]] call CBA_fnc_addPerFrameHandler;
    };
}, TASK_SLEEP, [_taskID,_positionEnd,_veh,_cleanup]] call CBA_fnc_addPerFrameHandler;
