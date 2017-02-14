/*
Author:
Killzone Kid

Description:
shuffles array

Arguments:
0: array to shuffle <ARRAY>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private _arr = _this select 0;
private _cnt = count _arr;

for "_i" from 1 to _cnt do {
    _arr pushBack (_arr deleteAt floor random _cnt);
};

_arr
