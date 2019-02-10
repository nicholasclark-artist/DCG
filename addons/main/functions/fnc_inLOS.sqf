/*
Author:
Nicholas Clark (SENSEI)

Description:
check if position B is visible from position A (positionASL)

Arguments:
0: position A <ARRAY>
1: position B <ARRAY>
2: object to ignore <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_posA",[],[[]]],
    ["_posB",[],[[]]],
    ["_ignore",objNull,[objNull]],
    ["_ignore2",objNull,[objNull]]
];

[_ignore, "VIEW", _ignore2] checkVisibility [_posA, _posB] > 0