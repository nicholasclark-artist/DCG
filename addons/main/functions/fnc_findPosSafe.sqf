/*
Author:
Nicholas Clark (SENSEI)

Description:
finds safe position

Arguments:
0: center position <ARRAY>
1: min distance from center <NUMBER>
2: max distance from center <NUMBER>
3: model to check <OBJECT,ARRAY,NUMBER>
4: allow water <NUMBER>
5: max gradient <NUMBER>
6: direction to search <NUMBER>

Return:
array (positionASL)
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_center",
	["_min",0],
	["_max",50],
	["_model",objNull],
	["_water",-1],
	["_gradient",-1],
	["_dir",-1]
];

if (_dir < 0) then {
	_dir = random 360;
};

private _pos = _center getPos [floor (random ((_max - _min) + 1)) + _min, _dir];
_pos set [2,getTerrainHeightASL _pos];

if !(_model isEqualTo objNull) then {
	if !([_pos,_model,_water,_gradient] call FUNC(isPosSafe)) then {
		_pos = _center;
	};
};

_pos