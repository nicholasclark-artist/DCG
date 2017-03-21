/*
Author:
Nicholas Clark (SENSEI)

Description:
get region location

Arguments:
0: center position <ARRAY>

Return:
location
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]]
];

{
    if (_position inArea _x) exitWith {
        _x
    };
    nil
} forEach GVAR(regions);
