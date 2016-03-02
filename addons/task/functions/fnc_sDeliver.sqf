/*
Author:
Nicholas Clark (SENSEI)

Description:
deliver supplies to town

Arguments:
0: forced task position <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define HANDLER_SLEEP 10
#define RETURN_DIST 20
#define ENEMY_MINCOUNT 4
#define ENEMY_MAXCOUNT 12

private ["_posConvoy","_posDeliver","_locConvoy","_locDeliver","_veh","_type","_cargo","_grp","_location","_roads","_taskID","_taskTitle","_taskDescription","_wp","_cond"];
params [["_posArray",[]]];

_posConvoy = [];
_posDeliver = [];
_locConvoy = "";
_locDeliver = "";
_veh = objNull;
_type = "";
_cargo = "";
_grp = grpNull;

// CREATE TASK
if (count _posArray > 1) then {
	if ({CHECK_DIST2D(_x select 1,_posArray select 0,1000) && {CHECK_DIST2D(_x select 1,_posArray select 1,1000)}} count EGVAR(occupy,locations) isEqualTo 0) then {
		_posConvoy = _posArray select 0;
		_posDeliver = _posArray select 1;
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
	[0,0] spawn FUNC(select);
};

if (_posArray isEqualTo []) then {
	_roads = _posConvoy nearRoads 200;
	if !(_roads isEqualTo []) then {
		_posConvoy = getPos (selectRandom _roads);
		_posArray pushBack _posConvoy;
	};
	_roads = _posDeliver nearRoads 50;
	if !(_roads isEqualTo []) then {
		_posDeliver = getPos (selectRandom _roads);
		_posArray pushBack _posDeliver;
	};
};

if (count _posArray < 2) exitWith {
	[0,0] spawn FUNC(select);
};

call {
	if (EGVAR(main,playerSide) isEqualTo EAST) then {
		_type = "O_Truck_02_box_F";
	};
	if (EGVAR(main,playerSide) isEqualTo RESISTANCE) then {
		_type = "I_Truck_02_box_F";
	};
	_type = "B_Truck_01_box_F";
};

_veh = _type createVehicle _posConvoy;
_veh setDir random 360;
_veh setObjectTextureGlobal [1, "#(rgb,8,8,3)color(0.2,0.05,0.05,1)"];
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

_grp = [_posConvoy,0,4,EGVAR(main,playerSide)] call EFUNC(main,spawnGroup);
{
	if (random 1 < 0.5) then {
		_x setUnitPos "MIDDLE";
	};
} forEach units _grp;

// SET TASK
_taskID = format ["sDeliver_%1",diag_tickTime];
_taskTitle = "(S) Deliver Supplies";
_taskDescription = format["A convoy enroute to deliver medical supplies to %1 (%2) broke down somewhere near %3. Repair the convoy and complete the delivery.",_locDeliver, mapGridPosition _posDeliver, _locConvoy];

[true,_taskID,[_taskDescription,_taskTitle,""],_posConvoy,false,true,"Support"] call EFUNC(main,setTask);

// PUBLISH TASK
GVAR(secondary) = [QFUNC(sDeliver),_posArray];
publicVariable QGVAR(secondary);

// TASK HANDLER
[{
	params ["_args","_idPFH"];
	_args params ["_taskID","_posDeliver","_veh","_grp"];

	if (GVAR(secondary) isEqualTo []) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "CANCELED"] call EFUNC(main,setTaskState);
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);
	};

	if !(alive _veh) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "FAILED"] call EFUNC(main,setTaskState);
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);
	};

	if (CHECK_DIST2D(_posDeliver,_veh,RETURN_DIST) && {speed _veh < 1}) exitWith {
		[_idPFH] call CBA_fnc_removePerFrameHandler;
		[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
		((units _grp) + [_veh]) call EFUNC(main,cleanup);
		[0] spawn FUNC(select);

		if (random 1 < 0.5) then {
			_posArray = [getpos _veh,50,400,300] call EFUNC(main,findPosGrid);
			{
				if !([_x,200] call EFUNC(main,getNearPlayers) isEqualTo []) then {
					_posArray deleteAt _forEachIndex;
				};
			} forEach _posArray;

			if !(_posArray isEqualTo []) then {
				_grp = [selectRandom _posArray,0,[ENEMY_MINCOUNT,ENEMY_MAXCOUNT] call EFUNC(main,setStrength)] call EFUNC(main,spawnGroup);
				_wp = _grp addWaypoint [getposATL _veh,0];
				_wp setWaypointBehaviour "AWARE";
				_wp setWaypointFormation "STAG COLUMN";
				_cond = "!(behaviour this isEqualTo ""COMBAT"")";
				_wp setWaypointStatements [_cond, format ["thisList call %1;",QEFUNC(main,cleanup)]];
			};
		};
	};
}, HANDLER_SLEEP, [_taskID,_posDeliver,_veh,_grp]] call CBA_fnc_addPerFrameHandler;