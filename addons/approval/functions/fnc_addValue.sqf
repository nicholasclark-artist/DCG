/*
Author:
Nicholas Clark (SENSEI)

Description:
add approval value to region

Arguments:
0: center position <ARRAY>
1: value <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",[],[[]]],
    ["_add",0,[0]]
];

private _region = [_position] call FUNC(getRegion);
private _value = _region getVariable QGVAR(regionValue);
ISNILS(_value,AV_DEFAULT);
private _newValue = _value + _add;
_region setVariable [QGVAR(regionValue),_newValue];

_newValue
