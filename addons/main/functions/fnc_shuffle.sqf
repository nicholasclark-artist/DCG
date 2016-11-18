/*
Author:
Killzone Kid

Description:
shuffles array

Arguments:
0: array to shuffle <ARRAY>
1: shuffle iterations <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private _arr = _this select 0;
private _cnt = count _arr;

for "_i" from 1 to ((_this select 1) max _cnt) do {
    _arr pushBack (_arr deleteAt floor random _cnt);
};

_arr
