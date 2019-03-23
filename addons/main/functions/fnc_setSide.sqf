/*
Author:
Nicholas Clark (SENSEI)

Description:
switches an array of units to another side and groups them

Arguments:
0: array of units <ARRAY>
1: side of new group <SIDE>

Return:
group
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_units",[],[[]]],
    ["_side",GVAR(enemySide),[sideUnknown]]
];

private _newgrp = createGroup _side;
_newgrp deleteGroupWhenEmpty true;

{
    [_x] joinSilent grpNull;
    [_x] joinSilent _newgrp;
} forEach _units;

_newgrp