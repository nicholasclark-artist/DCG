/*
Author:
Nicholas Clark (SENSEI)

Description:
get position offset using boundingBox center, necessary because object's pivot may not be at object's center

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

// _pos vectorAdd ([_obj] call FUNC(getObjectCenter) vectorDiff (_obj worldToModel (getPosATL _obj)))

private _posObj = getPos _obj;
private _posObjCenter = _obj modelToWorld ([_obj] call FUNC(getObjectCenter)); 

_pos getPos [_posObj distance2D _posObjCenter,(getDir _obj)]