/*
Author:
Nicholas Clark (SENSEI)

Description:
add approval value to region

Arguments:
0: center position <ARRAY>
1: value <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_add",0,[0]]
];

private _region = [_position] call FUNC(getRegion);

// debug empty values
if (_region isEqualTo []) exitWith {};

private _value = _region select 1;

// calculate new value
private _newValue = (_value select 1) + _add;
_value set [1,_newValue];

// calculate new color, [R,G,B,A]
private _colorValue = linearConversion [AP_MIN,AP_MAX,_newValue,0,1,true];
private _newColor = [1 - _colorValue,_colorValue,0,1];
_value set [3,_newColor];

[GVAR(regions),_region select 0,_value] call CBA_fnc_hashSet;

nil