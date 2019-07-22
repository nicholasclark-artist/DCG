/*
Author:
Nicholas Clark (SENSEI)

Description:
calculate polygon's area

Arguments:
0: polygon vertices <ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_polygon",[],[[]]]
];

private _area = 0;
private _j = _polygon select (count _polygon - 1);

for "_i" from 0 to count _polygon - 1 do {
    _area = _area + abs (((_j select 0) + (_polygon select _i select 0)) * ((_j select 1) - (_polygon select _i select 1)));
    _j = _polygon select _i;

    TRACE_2("",_i,_area);
};

_area / 2