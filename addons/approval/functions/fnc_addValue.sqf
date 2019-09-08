/*
Author:
Nicholas Clark (SENSEI)

Description:
add approval value to region

Arguments:
0: center position <ARRAY>
1: value <NUMBER>

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_add",0,[0]]
];

private _region = [_position] call FUNC(getRegion);

// calculate new value
private _newValue = (_region getVariable [QGVAR(value),0]) + _add;
_region setVariable [QGVAR(value),_newValue];
// TRACE_2("",_region,_newValue);
// calculate new color, [R,G,B,A]
private _colorValue = linearConversion [AP_MIN,AP_MAX,_newValue,0,1,true];
private _newColor = [1 - _colorValue,_colorValue,0,1];
_region setVariable [QGVAR(color),_newColor];

nil