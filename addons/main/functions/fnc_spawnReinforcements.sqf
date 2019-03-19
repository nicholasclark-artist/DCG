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

private _unitPool = [_side,0] call FUNC(getPool);
private _vehPool = [_side,1] call FUNC(getPool);
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

_grid = [_center,30,DIST_MAX,DIST_MIN,TR_SIZE,0] call EFUNC(main,findPosGrid);

if (_grid isEqualTo []) exitWith {
    WARNING("Reinforcements LZ undefined");
    false
};

private _lz = ASLtoAGL (selectRandom _grid);
private _type = selectRandom _vehPool;

if (!(_type isKindOf "Helicopter") || {([_type] call _fnc_getCargo) < 1}) then {
    if (_side isEqualTo EAST) exitWith {_type = "O_Heli_Light_02_unarmed_F"};
    if (_side isEqualTo WEST) exitWith {_type = "B_Heli_Light_01_F"};
    if (_side isEqualTo RESISTANCE) exitWith {_type = "I_Heli_light_03_unarmed_F"};
};

private _heli = createVehicle [_type,_center getPos [DIST_SPAWN,random 360],[],0,"FLY"];
_heli lock 3;

private _grp = createGroup _side;
private _pilot = _grp createUnit [selectRandom _unitPool, DEFAULT_SPAWNPOS, [], 0, "CAN_COLLIDE"];
[QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;
_pilot assignAsDriver _heli;
_pilot moveInDriver _heli;
_pilot disableAI "FSM";
_pilot setBehaviour "CARELESS";
_pilot addEventHandler ["GetOutMan",{deleteVehicle (_this select 0)}];

private _grpPatrol = [[0,0,0],0,MAX_CARGO(_heli),_side] call FUNC(spawnGroup);
[QEGVAR(cache,disableGroup),_grpPatrol] call CBA_fnc_serverEvent;

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
        _onComplete = format ["if ([%1,500] call %2 isEqualTo []) then {['%3',thisList] call CBA_fnc_serverEvent};",_center,QFUNC(getPlayers),QGVAR(cleanup)];
        [_grpPatrol, [_center, 50, 50, 0, false],"AWARE","NO CHANGE","UNCHANGED","NO CHANGE",_onComplete] call CBA_fnc_taskSearchArea;

        INFO_2("Reinforcement dismount at %1, target is %2",getPos leader _grpPatrol,_center);

        [
            {{alive (_x select 0)} count (fullCrew [_this,"cargo",false]) isEqualTo 0},
            {
                _this doMove [0,0,0];
                [QGVAR(cleanup),_this] call CBA_fnc_serverEvent;
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
        [QGVAR(cleanup),_heli] call CBA_fnc_serverEvent;
        INFO("Reinforcement vehicle destroyed");
    };
}, 1, [_heli]] call CBA_fnc_addPerFrameHandler;

true
