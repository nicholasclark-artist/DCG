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

params [
	"_arr",
	["_cnt",-1]
];

_cnt = _cnt max (count _arr);

for "_i" from 1 to _cnt do {
    _arr pushBack (_arr deleteAt floor random _cnt);
};

_arr