/*
Author:
Nicholas Clark (SENSEI)

Description:
get unit count based on player count

Arguments:
0: minimum count <NUMBER>
1: maximum count <NUMBER>
2: count multiplier <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_min",0,[0]],
    ["_max",50,[0]],
    ["_multiplier",1,[0]]
];

// DEBUG
// _str = "";
// for "_p" from 0 to 100 step 10 do {
//     _multiplier = 1;
//     _min = 0;
//     _max = 100;
//     _unitCount = ceil (((log (_p max 2) / log 2) * 10) * _multiplier);
//     _unitCount = (_unitCount max _min) min _max;
//     diag_log text (format["P:%1, U:%2",_p,_unitCount]);
// };
// diag_log text "END";

private _playerCount = count (call CBA_fnc_players);
private _unitCount = ceil (((log (_playerCount max 2) / log 2) * 10) * _multiplier);

(_unitCount max _min) min _max