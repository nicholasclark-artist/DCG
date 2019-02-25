/*
Author:
Nicholas Clark (SENSEI)

Description:
get KVP for position

Arguments:
0: position <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

private ["_ret","_value"];

_ret = [];

{
    // get copy of array
    _value =+ [GVAR(regions),_x] call CBA_fnc_hashGet;

    if (_position inPolygon _value#2) exitWith {
        _ret = [_x,_value];
    }; 
} forEach ([GVAR(regions)] call CBA_fnc_hashKeys);

_ret