/*
Author:
Nicholas Clark (SENSEI)

Description:
get position offset using boundingBox center, necessary because object's pivot may not be at object's center, returns positionASL

Arguments:
0: position to offset <ARRAY>
1: object <OBJECT>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_pos",[],[[]]],
    ["_obj",objNull,[objNull]]
];

private _ret = [];
private _pivot = getPosASL _obj;
private _center = _obj modelToWorld ([_obj] call FUNC(getObjectCenter)); 

// return object's original height 
_ret = _pos getPos [_pivot distance2D _center,getDir _obj];
_ret set [2,_pos select 2];

_ret