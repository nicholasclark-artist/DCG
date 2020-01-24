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
#define DIST_MIN 350
#define DIST_MAX 700
#define DIST_SPAWN 5000
#define TR_SIZE 15

params [
    ["_position",[],[[]]],
    ["_side",GVAR(enemySide),[sideUnknown]]
];

_grid = [_position,DIST_MAX/6,DIST_MAX,DIST_MIN,TR_SIZE,0] call EFUNC(main,findPosGrid);

if (_grid isEqualTo []) exitWith {
    WARNING("reinforcement LZ undefined");
    false
};

// select random landing position from grid
private _lz = selectRandom _grid;
_lz pushBack ASLZ(_lz);
_lz = ASLtoAGL _lz;

// get aircraft class name
private _type = selectRandom ([_side,2] call FUNC(getPool));

// must be a helicopter with at least 4 cargo seats
if (!(_type isKindOf "Helicopter") || {([_type] call FUNC(getCargoCount)) < 4}) then {
    if (_side isEqualTo EAST) exitWith {_type = "O_Heli_Light_02_unarmed_F"};
    if (_side isEqualTo WEST) exitWith {_type = "B_Heli_Light_01_F"};
    if (_side isEqualTo RESISTANCE) exitWith {_type = "I_Heli_light_03_unarmed_F"};
};

// spawn transport and create crew
private _transport = createVehicle [_type,_position getPos [DIST_SPAWN,random 360],[],0,"FLY"];

private _grp = createVehicleCrew _transport;
_grp addVehicle _transport;
_grp selectLeader (effectiveCommander _veh);

// set crew behaviors 
_transport setUnloadInCombat [false,false];
// (driver _transport) disableAI "FSM";
// (driver _transport) setBehaviourStrong "CARELESS";

// in case 'setUnloadInCombat' fails
{
    _x addEventHandler ["GetOutMan",{
        unassignVehicle (_this select 0);
        deleteVehicle (_this select 0);
    }];
} forEach crew _transport;

// lock players out 
_transport lock 3;

// disable caching so waypoints function correctly
[QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;

// spawn QRF group
private _grpReinforce = [DEFAULT_SPAWNPOS,0,MAX_CARGO(_transport),_side] call FUNC(spawnGroup);

// disable caching
[QEGVAR(cache,disableGroup),_grpReinforce] call CBA_fnc_serverEvent;

// place group in cargo
[
    {(_this select 0) getVariable [QEGVAR(main,ready),false]},
    {
        params ["_grpReinforce","_transport"];

        {
            _x assignAsCargoIndex [_transport,_forEachIndex];
            _x moveInCargo _transport;
        } forEach (units _grpReinforce);
    },
    [_grpReinforce,_transport]
] call CBA_fnc_waitUntilAndExecute;

// move to landing zone
[
    _transport,
    _lz,
    {
        params ["_transport","_grpReinforce","_position"];

        // dismount transport
        _grpReinforce leaveVehicle _transport;

        // if reinforcements reach position and no players near then delete group
        _onComplete = format ["if ([%1,500] call %2 isEqualTo []) then {['%3',thisList] call CBA_fnc_serverEvent};",_position,QFUNC(getPlayers),QGVAR(cleanup)];

        // search area around position
        [_grpReinforce,[_position,50,50,0,false],"AWARE","NO CHANGE","UNCHANGED","NO CHANGE",_onComplete] call CBA_fnc_taskSearchArea;

        INFO_2("reinforcement dismount at %1, target at %2",getPosATL leader _grpReinforce,_position);

        // send transport away and cleanup
        [
            {
                {group _x isEqualTo (_this select 1)} count (crew (_this select 0)) isEqualTo 0
            },
            {
                (_this select 0) move DEFAULT_POS;
                [QGVAR(cleanup),_this select 0] call CBA_fnc_serverEvent;
            },
            [_transport,_grpReinforce]
        ] call CBA_fnc_waitUntilAndExecute;
    },
    [_transport,_grpReinforce,_position]
] call FUNC(landAt);

// watch if heli is destroyed
[{
    params ["_args","_idPFH"];
    _args params ["_transport"];

    if (isTouchingGround _transport && {!alive _transport || !canMove _transport || fuel _transport isEqualTo 0}) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        [QGVAR(cleanup),_transport] call CBA_fnc_serverEvent;
        INFO("reinforcement vehicle destroyed");
    };
},1,[_transport]] call CBA_fnc_addPerFrameHandler;

true