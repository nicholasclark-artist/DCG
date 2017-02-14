/*
Author:
Nicholas Clark (SENSEI)

Description:
send reinforcements to position

Arguments:
0: center position <ARRAY>
1: reinforcements side <SIDE>
2: distance from center to land reinforcements <NUMBER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO(VEH) ((VEH) emptyPositions "cargo") min 6
#define DIST_MIN 350
#define DIST_MAX DIST_MIN*2
#define DIST_SPAWN DIST_MAX*4
#define TR_SIZE 15

params [
	"_center",
	["_side",GVAR(enemySide),[sideUnknown]]
];

private _lz = [];
private _unitPool = [];
private _vehPool = [];
private _backup = "";
private _distSpawn = 2500;
private _fnc_getCargo = {
	params ["_class"];

	private _baseCfg = configFile >> "CfgVehicles" >> _class;
	private _numCargo = count ("
		if (isText(_x >> 'proxyType') && {getText(_x >> 'proxyType') isEqualTo 'CPCargo'}) then {
			true
		};
	"configClasses (_baseCfg >> "Turrets")) + getNumber (_baseCfg >> "transportSoldier");

	_numCargo
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
    if (_side isEqualTo RESISTANCE) exitWith {
        _unitPool = GVAR(unitPoolInd);
    	_vehPool = GVAR(airPoolInd);
    	_backup = "I_Heli_light_03_unarmed_F";
	};
};

_grid = [_center,30,DIST_MAX,DIST_MIN,TR_SIZE,0] call EFUNC(main,findPosGrid);

if (_grid isEqualTo []) exitWith {
	INFO("Reinforcements LZ undefined");
    false
};

_lz = selectRandom _grid;

private _spawnPos = [_center,DIST_SPAWN,DIST_SPAWN + 500] call FUNC(findPosSafe);
private _type = selectRandom _vehPool;

if (!(_type isKindOf "Helicopter") || {([_type] call _fnc_getCargo) < 1}) then {
	_type = _backup;
};

private _heli = createVehicle [_type,_spawnPos,[],0,"FLY"];
_heli lock 3;
_heli flyInHeight 100;
_heli allowCrewInImmobile true;

private _grp = createGroup _side;
private _pilot = _grp createUnit [selectRandom _unitPool,[0,0,0], [], 0, "NONE"];
_pilot assignAsDriver _heli;
_pilot moveInDriver _heli;
_pilot setBehaviour "CARELESS";
_pilot disableAI "FSM";

private _grpPatrol = [[0,0,0],0,MAX_CARGO(_heli),_side,false,0.3] call FUNC(spawnGroup);

// place patrol group in cargo
[
	{count units (_this select 1) >= MAX_CARGO(_this select 0)},
	{
		params ["_heli","_grpPatrol"];

		{
			_x assignAsCargoIndex [_heli, _forEachIndex];
			_x moveInCargo _heli;
		} forEach (units _grpPatrol);
	},
	[_heli,_grpPatrol]
] call CBA_fnc_waitUntilAndExecute;

// add waypoint to pilot
_wp = _grp addWaypoint [_lz, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "NORMAL";
_wp setWaypointStatements ["true", "(vehicle this) land ""GET OUT"";"];

_wp = _grp addWaypoint [_spawnPos, 0];
_wp setWaypointType "MOVE";
_wp setWaypointSpeed "FULL";
_wp setWaypointStatements ["true", "deleteVehicle (vehicle this); deleteVehicle this;"];

// patrol group dismount
[
	{((getPosATL (vehicle leader (_this select 1))) select 2) <= 5},
	{
		params ["_heli","_grpPatrol","_center"];

		_grpPatrol leaveVehicle _heli;
        _onComplete = format ["
            if ([%1,1000] call %2 isEqualTo []) then {
                thisList call %3;
            };
        ",_center,QFUNC(getPlayers),QFUNC(cleanup)];
        [_grpPatrol, [_center, 50, 50, 0, false],"AWARE","NO CHANGE","UNCHANGED","NO CHANGE",_onComplete] call CBA_fnc_taskSearchArea;

        INFO_2("Reinforcement dismount at %1, target is %2",getPos leader _grpPatrol,_center);
	},
	[_heli,_grpPatrol,_center]
] call CBA_fnc_waitUntilAndExecute;

// watch if heli is destroyed
[{
    params ["_args","_idPFH"];
    _args params ["_heli","_pilot","_spawnPos","_lz"];

    if (!alive _pilot || {isNull objectParent _pilot} || {isTouchingGround _heli && (!(canMove _heli) || (fuel _heli isEqualTo 0))}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        _heli call FUNC(cleanup);

        INFO("Reinforcement vehicle destroyed");
    };
}, 1, [_heli,_pilot,_spawnPos,_lz]] call CBA_fnc_addPerFrameHandler;

true
