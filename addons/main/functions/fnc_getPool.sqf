/*
Author:
Nicholas Clark (SENSEI)

Description:
get unit pool 

Arguments:
0: side <SIDE>
1: type <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_side",GVAR(enemySide),[sideUnknown]],
    ["_type",0,[0]]
];

private _pool = [];

if (_side isEqualTo EAST) exitWith {
    if (_type isEqualTo 0) exitWith {
        _pool = GVAR(unitPoolEast)
    };
    if (_type isEqualTo 1) exitWith {
        _pool = GVAR(vehPoolEast)
    };
    if (_type isEqualTo 2) exitWith {
        _pool = GVAR(airPoolEast)
    };
};

if (_side isEqualTo WEST) exitWith {
    if (_type isEqualTo 0) exitWith {
        _pool = GVAR(unitPoolWest)
    };
    if (_type isEqualTo 1) exitWith {
        _pool = GVAR(vehPoolWest)
    };
    if (_type isEqualTo 2) exitWith {
        _pool = GVAR(airPoolWest)
    };
};

if (_side isEqualTo INDEPENDENT) exitWith {
    if (_type isEqualTo 0) exitWith {
        _pool = GVAR(unitPoolInd)
    };
    if (_type isEqualTo 1) exitWith {
        _pool = GVAR(vehPoolInd)
    };
    if (_type isEqualTo 2) exitWith {
        _pool = GVAR(airPoolInd)
    };
};

_pool