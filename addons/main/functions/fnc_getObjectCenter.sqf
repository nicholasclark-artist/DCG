/*
Author:
Nicholas Clark (SENSEI)

Description:
get object center in model space

Arguments:
0: object <OBJECT>
1: use minimum extent <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_obj",objNull,[objNull]],
    ["_min",true,[false]]
];

private _bbr = 0 boundingBoxReal _obj;
private _ret = ((_bbr select 0) vectorAdd (_bbr select 1)) vectorMultiply 0.5;

// snap center to minimum extent by default, useful when placing objects
if (_min) then {
    _ret = _ret vectorDiff [0,0,abs ((_bbr select 0) select 2)];
};

_ret