/*
Author:
Nicholas Clark (SENSEI)

Description:
shuffles array

Arguments:
0: array to shuffle <ARRAY>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

private _arr = _this select 0;
private _temp =+ _arr;

for "_i" from (count _arr) to 1 step -1 do {
    _arr set [_i - 1, (_temp deleteAt (floor random _i))];
};

nil