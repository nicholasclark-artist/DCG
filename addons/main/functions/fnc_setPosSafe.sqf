/*
Author:
Nicholas Clark (SENSEI)

Description:
set object at safe position

Arguments:
0: object <OBJEECT>
1: positionASL <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_pos",[0,0,0],[[]]]
];

_obj setVectorUp surfaceNormal _pos;
_obj setPosASL _pos;
