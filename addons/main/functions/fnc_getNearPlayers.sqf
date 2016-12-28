/*
Author:
Nicholas Clark (SENSEI)

Description:
gets near players

Arguments:
0: center position <ARRAY>
1: distance from center to check <NUMBER>
2: Z-axis distance

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_center",
    ["_dist",50,[0]],
    ["_z",-1,[0]]
];

allPlayers inAreaArray [_center,_dist,_dist,0,false,_z]
