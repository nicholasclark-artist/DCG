/*
Author:
Nicholas Clark (SENSEI)

Description:
gets near players

Arguments:
0: center position <ARRAY>
1: radius from center to check <NUMBER>
2: Z-axis distance

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_center",
    ["_radius",50,[0]],
    ["_z",-1,[0]]
];

// be sure _center z-axis is correctly formatted if _z is used
allPlayers inAreaArray [_center,_radius,_radius,0,false,_z]
