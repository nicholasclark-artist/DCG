/*
Author:
Nicholas Clark (SENSEI)

Description:
find positionAGL at roadside

Arguments:
0: road <OBJECT>
1: offset distance from roadside <NUMBER>

Return:
position
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_road",objNull,[objNull]],
    ["_offset",0,[0]]
];

private _info = getRoadInfo _road;
private _dir = (_info select 6) getDir (_info select 7);
_dir = _dir + (180 * round (random 1));

_road getRelPos [((_info select 1) * 0.5) + _offset, _dir + 90];