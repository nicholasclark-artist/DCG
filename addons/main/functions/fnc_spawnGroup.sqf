/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn group

Arguments:
0: position where group will spawn <ARRAY>
1: type of group, 0: infantry, 1: land/sea vehicle, 2: air <NUMBER>
2: number of units in infantry group <NUMBER>
3: side of group <SIDE>
4: delay between unit spawns <NUMBER>
5: fill vehicle cargo or number of units to spawn in cargo <BOOL,NUMBER>
6: disable group caching <BOOL>

Return:
group
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO 6

params [
    ["_pos",[],[[]]],
    ["_type",0,[0]],
    ["_count",1,[0]],
    ["_side",GVAR(enemySide),[sideUnknown]],
    ["_delay",1,[0]],
    ["_cargo",0,[false,0]],
    ["_disableCaching",false,[false]]
];

private _grp = createGroup [_side,true];
private _check = [];
private _unitPool = [_side,0] call FUNC(getPool);
private _vehPool = [_side,1] call FUNC(getPool);
private _airPool = [_side,2] call FUNC(getPool);
private _shipPool = [_side,3] call FUNC(getPool);

// check for disable caching
if (_disableCaching) then {
    [QEGVAR(cache,disableGroup),_grp] call CBA_fnc_serverEvent;
};

// don't consider height to simplify spawning
_pos =+ _pos;
_pos resize 2;

if (_type isEqualTo 0) then {
    [{
        params ["_args","_idPFH"];
        _args params ["_pos","_grp","_unitPool","_count","_check"];

        if (count _check >= _count) exitWith {
            _grp setVariable [QGVAR(ready),true,false];
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        (selectRandom _unitPool) createUnit [_pos,_grp];

        _check pushBack 0;
    },_delay,[_pos,_grp,_unitPool,_count,_check]] call CBA_fnc_addPerFrameHandler;
} else {
    private ["_veh"];

    if (_type isEqualTo 1) then {
        if (surfaceIsWater _pos) then {
            _veh = (selectRandom _shipPool) createVehicle _pos;

        } else {
            _veh = (selectRandom _vehPool) createVehicle _pos;
            _veh setVectorUp surfaceNormal getPosATL _veh;
        };
    } else {
        _veh = createVehicle [selectRandom _airPool,_pos,[],100,"FLY"];
    };

    /*
        a temporary group is created with 'createVehicleCrew'
        any event that triggers on group creation will run twice
    */

    // use createVehicleCrew to create accurate crew, so DCG's faction/filter settings do not interfere
    private _grpTemp = createVehicleCrew _veh;
    _grpTemp deleteGroupWhenEmpty true;

    // vehicle units are created in temp group, we must force caching for actual group
    [QEGVAR(cache,enableGroup),_grp] call CBA_fnc_serverEvent;

    crew _veh joinSilent _grp;
    _grp addVehicle _veh;
    _grp selectLeader (effectiveCommander _veh);
    _veh setUnloadInCombat [true,true];

    if (_cargo isEqualType false) then { // get cargo count if boolean passed
        _cargo = if (_cargo) then {
            _veh emptyPositions "cargo";
        } else {
            0;
        };
    } else { // don't spawn more cargo units than cargo positions
        _cargo = (_veh emptyPositions "cargo") min _cargo;
    };

    if (_cargo > 0) then {
        private ["_unit"];

        [{
            params ["_args","_idPFH"];
            _args params ["_grp","_unitPool","_veh","_count"];

            if (!(alive _veh) || {count crew _veh >= _count}) exitWith {
                _grp setVariable [QGVAR(ready),true,false];
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };

            _unit = _grp createUnit [selectRandom _unitPool,DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];

            // assign units before 'moveIn' so they dont momentarily dismount
            _unit assignAsCargo _veh;
            _unit moveInCargo _veh;
        },_delay,[_grp,_unitPool,_veh,(_cargo min MAX_CARGO) + (count crew _veh)]] call CBA_fnc_addPerFrameHandler;
    } else {
        _grp setVariable [QGVAR(ready),true,false];
    };
};

// possible bug: behavior commands do not function when applied to group before all units are created, so apply default behaviors here, after spawns are finished
_grp setBehaviourStrong "SAFE";

_grp