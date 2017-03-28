/*
Author:
Nicholas Clark (SENSEI)

Description:
check if position A is in line of sight of position B (positionASL)

Arguments:
0: position A <ARRAY>
1: position B <ARRAY>
2: object to ignore <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_posA",[0,0,0],[[]]],
    ["_posB",[0,0,0],[[]]],
    ["_ignore",objNull,[objNull]]
];

[_ignore, "VIEW"] checkVisibility [_posA, _posB] > 0
