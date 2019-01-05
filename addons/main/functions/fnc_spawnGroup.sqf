/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn group

Arguments:
0: position where group will spawn <ARRAY>
1: type of group <NUMBER>
2: number of units in group <NUMBER>
3: side of group <SIDE>
4: delay between unit spawns <NUMBER>
5: fill vehicle cargo <BOOL>

Return:
group
__________________________________________________________________*/
#include "script_component.hpp"
#define MAX_CARGO 4

params [
    ["_pos",[0,0,0],[[]]],
    ["_type",0,[0]],
    ["_count",1,[0]],
    ["_side",GVAR(enemySide),[sideUnknown]],
    ["_delay",1,[0]],
    ["_cargo",false,[false]]
];

private _grp = createGroup _side;
private _drivers = [];
private _check = [];
private _unitPool = [_side,0] call FUNC(getPool);
private _vehPool = [_side,1] call FUNC(getPool);
private _airPool = [_side,2] call FUNC(getPool);

_grp deleteGroupWhenEmpty true;

_pos =+ _pos;
_pos resize 2;

if (_type isEqualTo 0) exitWith {
    [{
        params ["_args","_idPFH"];
        _args params ["_pos","_grp","_unitPool","_count","_check"];

        if (count _check isEqualTo _count) exitWith {
            [_idPFH] call CBA_fnc_removePerFrameHandler;
        };

        (selectRandom _unitPool) createUnit [_pos, _grp];

        _check pushBack 0;
    }, _delay, [_pos,_grp,_unitPool,_count,_check]] call CBA_fnc_addPerFrameHandler;

    _grp
};

[{
    params ["_args","_idPFH"];
    _args params ["_pos","_grp","_type","_count","_unitPool","_vehPool","_airPool","_check","_cargo","_delay"];

    if (count _check isEqualTo _count) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    private "_veh";

    if (_type isEqualTo 1) then {
        _veh = createVehicle [selectRandom _vehPool, _pos, [], 0, "NONE"];
        _veh setVectorUp surfaceNormal getPos _veh;
    } else {
        _veh = createVehicle [selectRandom _airPool, _pos, [], 100, "FLY"];
    };

    _unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
    _unit setVariable [ISDRIVER,true];
    _unit moveInDriver _veh;

    if ((_veh emptyPositions "gunner") > 0) then {
        _unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
        _unit moveInGunner _veh;
    };

    if (_cargo) then {
        _veh setUnloadInCombat [true,false];

        [{
            params ["_args","_idPFH"];
            _args params ["_grp","_unitPool","_veh","_count"];

            if (!(alive _veh) || {count crew _veh >= _count}) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
            };

            _unit = _grp createUnit [selectRandom _unitPool, [0,0,0], [], 0, "NONE"];
            _unit moveInCargo _veh;
        }, _delay, [_grp,_unitPool,_veh,((_veh emptyPositions "cargo") min MAX_CARGO) + (count crew _veh)]] call CBA_fnc_addPerFrameHandler;
    };

    _check pushBack 0;
}, _delay, [_pos,_grp,_type,_count,_unitPool,_vehPool,_airPool,_check,_cargo,_delay]] call CBA_fnc_addPerFrameHandler;

_grp
