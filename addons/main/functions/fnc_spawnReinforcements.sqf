/*
Author:
Nicholas Clark (SENSEI)

Description:
send reinforcements to position

Arguments:
0: center position <ARRAY>
1: reinforcement side <SIDE>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO(VEH) ((VEH) emptyPositions "cargo") min 6
#define DIST_MIN 250
#define DIST_MAX 400
#define DIST_SPAWN 3000
#define TR_SIZE 15

params [
	["_center",[],[[]]],
	["_side",GVAR(enemySide),[sideUnknown]]
];

private _unitPool = [];
private _vehPool = [];
private _backup = "";
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

private _lz = ASLtoAGL (selectRandom _grid);
private _type = selectRandom _vehPool;

if (!(_type isKindOf "Helicopter") || {([_type] call _fnc_getCargo) < 1}) then {
	_type = _backup;
};

private _heli = createVehicle [_type,_center getPos [DIST_SPAWN,random 360],[],0,"FLY"];
_heli lock 3;

private _grp = createGroup _side;
private _pilot = _grp createUnit [selectRandom _unitPool,[0,0,0], [], 0, "NONE"];
[_grp] call EFUNC(cache,disableCache);
_pilot assignAsDriver _heli;
_pilot moveInDriver _heli;
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";
_pilot addEventHandler ["GetOutMan",{deleteVehicle (_this select 0)}];

private _grpPatrol = [[0,0,0],0,MAX_CARGO(_heli),_side] call FUNC(spawnGroup);
[_grpPatrol] call EFUNC(cache,disableCache);

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

// move to drop off position
[
    _heli,
    _lz,
    "LAND",
    {
        params ["_heli","_grpPatrol","_center"];

        _grpPatrol leaveVehicle _heli;
        _onComplete = format ["if ([%1,500] call %2 isEqualTo []) then {thisList call %3};",_center,QFUNC(getPlayers),QFUNC(cleanup)];
        [_grpPatrol, [_center, 50, 50, 0, false],"AWARE","NO CHANGE","UNCHANGED","NO CHANGE",_onComplete] call CBA_fnc_taskSearchArea;

        INFO_2("Reinforcement dismount at %1, target is %2",getPos leader _grpPatrol,_center);

        [
            {{alive (_x select 0)} count (fullCrew [_this,"cargo",false]) isEqualTo 0},
            {
                _this doMove [0,0,0];
                _this call FUNC(cleanup);
            },
            _heli
        ] call CBA_fnc_waitUntilAndExecute;
    },
    [_grpPatrol,_center]
] call EFUNC(main,landAt);

// watch if heli is destroyed
[{
    params ["_args","_idPFH"];
    _args params ["_heli"];

    if (isTouchingGround _heli && {!alive _heli || !canMove _heli || fuel _heli isEqualTo 0}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        _heli call FUNC(cleanup);
        INFO("Reinforcement vehicle destroyed");
    };
}, 1, [_heli]] call CBA_fnc_addPerFrameHandler;

true
