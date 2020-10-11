/*
Author:
Nicholas Clark (SENSEI)

Description:
get unit count based on player count

Arguments:
0: target count <NUMBER>
1: maximum count <NUMBER>
2: player coefficient <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_target",0,[0]],
    ["_max",32,[0]],
    ["_c",0.5,[0]]
];

// _l = 0;

// for "_p" from 0 to 100 step 5 do {
//     _target = 4;
//     _max = 64;
//     _c = 0.75;

//     _u = _max min ceil (_target + (_p * _c));

//     diag_log text (format["Players:%1,Units:%2,Diff:%3",_p,_u,_u - _l]);

//     _l = _u;
// };

// diag_log text "END";

_max min ceil (_target + (count (call CBA_fnc_players) * _c))