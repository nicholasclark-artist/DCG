/*
Author:
Nicholas Clark (SENSEI)

Description:
get unit count based on player count

Arguments:
0: minimum number of units <NUMBER>
1: maximum number of units <NUMBER>
2: unit multiplier <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_min",0,[0]],
    ["_max",100,[0]],
    ["_m",5,[0]]
];

// private ["_b","_min","_max","_u","_l"];

// _l = 0;

// for "_p" from 0 to 100 step 5 do {
//     _m = 10;
//     _min = 0;
//     _max = 200;
//     _u = ceil ((log (_p max 2) / log 2) * _m);
//     _u = (_u max _min) min _max;
//     diag_log text (format["Players:%1,Units:%2,Diff:%3",_p,_u,_u - _l]);
//     _l = _u;
// };
// diag_log text "END";

private _u = ceil ((log ((count (call CBA_fnc_players)) max 2) / log 2) * _m);

(_u max _min) min _max