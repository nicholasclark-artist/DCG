/*
Author:
Nicholas Clark (SENSEI)

Description:
get terrain angle in degrees

Arguments:
0: position <ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",DEFAULT_POS,[[]]]
];

aCos ([0,0,1] vectorCos (surfaceNormal _position))