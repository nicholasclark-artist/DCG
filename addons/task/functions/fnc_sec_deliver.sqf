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

params [["_posArray",[]]];

// CREATE TASK
_taskID = str diag_tickTime;
_posConvoy = [];
_posDeliver = [];
_locConvoy = "";
_locDeliver = "";
_type = "";
_cargo = "";

if (count _posArray > 1) then {
	if ({CHECK_DIST2D(_x select 1,(_posArray select 0) select 0,1000) && {CHECK_DIST2D(_x select 1,(_posArray select 1) select 0,1000)}} count EGVAR(occupy,locations) isEqualTo 0) then {
		_posConvoy = (_posArray select 0) select 0;
		_locConvoy = (_posArray select 0) select 1;
		_posDeliver = (_posArray select 1) select 0;
		_locDeliver = (_posArray select 1) select 1;
	};
};

if (count EGVAR(main,locations) > 1 && {_posConvoy isEqualTo []}) then {
	if (CHECK_ADDON_2(occupy)) then {
		if (count EGVAR(main,locations) >= (count EGVAR(occupy,locations)) + 2) then {
			_location = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations))});
			_locConvoy = _location select 0;
			_posConvoy = _location select 1;
			_location = selectRandom (EGVAR(main,locations) select {!(_x in EGVAR(occupy,locations)) && !(_x isEqualTo _posConvoy)});
			_locDeliver = _location select 0;
			_posDeliver = _location select 1;
		};
	} else {
		_location = selectRandom EGVAR(main,locations);
		_locConvoy = _location select 0;
		_posConvoy = _location select 1;
		_location = selectRandom (EGVAR(main,locations) select {!(_x isEqualTo _posConvoy)});
		_locDeliver = _location select 0;
		_posDeliver = _location select 1;
	};
};

if (_posConvoy isEqualTo [] || {_posDeliver isEqualTo []}) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

if (_posArray isEqualTo []) then {
	_roads = _posConvoy nearRoads 200;
	if !(_roads isEqualTo []) then {
		_posConvoy = getPos (selectRandom _roads);
		_posArray pushBack [_posConvoy,_locConvoy];
	};
	_roads = _posDeliver nearRoads 50;
	if !(_roads isEqualTo []) then {
		_posDeliver = getPos (selectRandom _roads);
		_posArray pushBack [_posDeliver,_locDeliver];
	};
};

if (count _posArray < 2) exitWith {
	[TASK_TYPE,0] call FUNC(select);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) exitWith {
		_type = "O_Truck_02_box_F";
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) exitWith {
		_type = "I_Truck_02_box_F";
	};
	_type = "B_Truck_01_box_F";
};

_veh = _type createVehicle [0,0,0];
_veh setDir random 360;
_veh setPos _posConvoy;
_veh setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.27,0.27,0.27,1)"];
[_veh] call EFUNC(main,setVehDamaged);

if (CHECK_ADDON_1("ace_cargo")) then {
	if (CHECK_ADDON_1("ace_medical")) then {
		_cargo = "ACE_medicalSupplyCrate_advanced";
	} else {
		_cargo = "Medikit";
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

_grp = [_posConvoy,0,UNITCOUNT,EGVAR(main,playerSide),false,1] call EFUNC(main,spawnGroup);

[
	{count units (_this select 0) isEqualTo UNITCOUNT},
	{
		{
			if (random 1 < 0.5) then {
				_x setUnitPos "MIDDLE";
			};
		} forEach units (_this select 0);
	},
	[_grp]
] call CBA_fnc_waitUntilAndExecute;

// SET TASK
_taskDescription = format["A convoy enroute to deliver medical supplies to %1 broke down somewhere near %2. Repair the convoy and complete the delivery to %1.",_locDeliver, _locConvoy];
[true,_taskID,[_taskDescription,TASK_TITLE,""],_posConvoy,false,true,"run"] call EFUNC(main,setTask);

// PUBLISH TASK
TASK_PUBLISH(_posArray);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_posDeliver","_veh","_grp"];

	if (GVAR(secondary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		[TASK_TYPE,30] call FUNC(select);
	};

	if !(alive _veh) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos _veh,TASK_AV * -1);
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		TASK_EXIT;
	};

	if (CHECK_DIST2D(_posDeliver,_veh,TASK_DIST_RET) && {speed _veh < 1}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call EFUNC(main,setTaskState);
		TASK_APPROVAL(getPos _veh,TASK_AV);
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		TASK_EXIT;

		if (random 1 < 0.5) then {
			_posArray = [getpos _veh,50,400,300] call EFUNC(main,findPosGrid);
			{
				if !([_x,150] call EFUNC(main,getNearPlayers) isEqualTo []) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;

			if !(_posArray isEqualTo []) then {
				_grp = [selectRandom _posArray,0,TASK_STRENGTH,EGVAR(main,enemySide),false,1] call EFUNC(main,spawnGroup);
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
}, TASK_SLEEP, [_taskID,_posDeliver,_veh,_grp]] call CBA_fnc_addPerFrameHandler;
