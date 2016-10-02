/*
Author:
Nicholas Clark (SENSEI)

Description:
send reinforcements to position

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO(VEH) (VEH emptyPositions "cargo") min 6
#define BUFFER 200
#define ITERATIONS 100
#define FLATEMPTY(POS) POS isFlatEmpty [15, -1, 0.45, 10, 0, false, objNull]

params [
	"_center",
	["_side",GVAR(enemySide)],
	["_dist",300],
	["_distSpawn",1500],
	["_wpType","SAD"],
	["_patrol",false],
	["_findHelipad",false]
];

private _lz = [];
private _unitPool = [];
private _vehPool = [];
private _backup = "";

private _fnc_getCargo = {
	params ["_vehType"];

	private _baseCfg = configFile >> "CfgVehicles" >> _vehType;

	private _numCargo = count ("
		if ( isText(_x >> 'proxyType') && { getText(_x >> 'proxyType') isEqualTo 'CPCargo' } ) then {
			true
		};
	"configClasses ( _baseCfg >> "Turrets" )) + getNumber ( _baseCfg >> "transportSoldier" );

	_numCargo
};

private _fnc_getNearHelipad = {
	params ["_pos",["_range",100],["_size",8]];

	private _helipad = (nearestObjects [_pos, ["Land_HelipadCircle_F","Land_HelipadCivil_F","Land_HelipadEmpty_F","Land_HelipadRescue_F","Land_HelipadSquare_F","Land_JumpTarget_F"], _range]) select 0;

	if !(isNil "_helipad") then {
		if ([getPos _helipad,_size,0,0.35] call FUNC(isPosSafe)) then {
			_pos = getPosASL _helipad;
		};
	};

	_pos
};

call {
	if (_side isEqualTo EAST) exitWith {
		_unitPool = GVAR(unitPoolEast);
		_vehPool = GVAR(airPoolEast);
		_backup = "O_Heli_Light_02_unarmed_F";
	};
	if (_side isEqualTo WEST) exitWith {
		_unitPool = GVAR(unitPoolWest);
		_vehPool = GVAR(airPoolWest);
		_backup = "B_Heli_Light_01_F";
	};
	_unitPool = GVAR(unitPoolInd);
	_vehPool = GVAR(airPoolInd);
	_backup = "I_Heli_light_03_unarmed_F";
};

for "_i" from 1 to ITERATIONS do {
	_lz = [_center,_dist,_dist+BUFFER] call FUNC(findPosSafe);
	if !(FLATEMPTY(_lz) isEqualTo []) exitWith {};
};

if (FLATEMPTY(_lz) isEqualTo []) exitWith {
	INFO("Reinforcements LZ undefined.");
};

if (_findHelipad) then {
	_lz = [_lz] call _fnc_getNearHelipad;
};

private _pos = [_lz,_distSpawn,_distSpawn+BUFFER] call FUNC(findPosSafe);

private _type = selectRandom _vehPool;

if (!(_type isKindOf "Helicopter") || {([_type] call _fnc_getCargo) < 1}) then {
	_type = _backup;
};

private _veh = createVehicle [_type,_pos,[],0,"FLY"];
_veh flyInHeight 100;
_veh lock 3;

private _grp = createGroup _side;
_grp setBehaviour "CARELESS";

private _pilot = _grp createUnit [selectRandom _unitPool,[0,0,0], [], 0, "NONE"];
_pilot moveInDriver _veh;
_pilot allowfleeing 0;

private _grpPatrol = [_pos,0,MAX_CARGO(_veh),_side,false,0.5] call FUNC(spawnGroup);

[
	{count units (_this select 2) isEqualTo MAX_CARGO((_this select 3))},
	{
		_this params ["_pilot","_grp","_grpPatrol","_veh","_pos","_center","_wpType","_patrol","_lz"];

		{
			_x assignAsCargoIndex [_veh, _forEachIndex];
			_x moveInCargo _veh;
		} forEach (units _grpPatrol);

		_wp1 = _grp addWaypoint [_lz, 0];
		_wp1 setWaypointType "TR UNLOAD";
		_wp2 = _grp addWaypoint [_pos, 0];
		_wp2 setWaypointStatements ["true", "deleteVehicle (vehicle this); deleteVehicle this;"];

		INFO_1("Reinforcements inbound to %1.",_lz);

		[{
			params ["_args","_idPFH"];
			_args params ["_center","_grpPatrol","_wpType","_patrol"];

			if (isNull objectParent (leader _grpPatrol)) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				INFO("Reinforcements complete.");

				_wp = _grpPatrol addWaypoint [_center, 0];
				_wp setWaypointType _wpType;
				_wp setWaypointSpeed "FULL";
				if (_patrol) then {
					_wp setWaypointStatements ["true", format["[units group this] call %1;",FUNC(setPatrol)]];
				} else {
					_wp setWaypointStatements ["true", format["if !(isPlayer(this findNearestEnemy this)) then {(units (group this)) call %1;}",FUNC(cleanup)]];
				};
			};
		}, 1, [_center,_grpPatrol,_wpType,_patrol]] call CBA_fnc_addPerFrameHandler;

		[{
			params ["_args","_idPFH"];
			_args params ["_veh","_pilot"];

			if (!alive _pilot || {isNull objectParent _pilot} || {isTouchingGround _veh && (!(canMove _veh) || (fuel _veh isEqualTo 0))}) exitWith {
				[_idPFH] call CBA_fnc_removePerFrameHandler;
				_pilot call FUNC(cleanup);
				_veh call FUNC(cleanup);

				INFO("Reinforcement vehicle destroyed.");
			};
		}, 1, [_veh,_pilot]] call CBA_fnc_addPerFrameHandler;
	},
	[_pilot,_grp,_grpPatrol,_veh,_pos,_center,_wpType,_patrol,_lz]
] call CBA_fnc_waitUntilAndExecute;