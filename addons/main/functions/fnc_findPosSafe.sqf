/*
Author:
Nicholas Clark (SENSEI)

Description:
finds safe position (positionASL)

Arguments:
0: center position <ARRAY>
1: min distance from center <NUMBER>
2: max distance from center <NUMBER>
3: min distance from object <NUMBER>
4: allow water <NUMBER>
5: max gradient <NUMBER>
6: direction to search <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_center",[0,0,0],[[]]],
	["_min",0,[0]],
	["_max",50,[0]],
	["_dist",0,[0]],
	["_water",-1,[0]],
	["_gradient",-1,[0]],
	["_dir",-1,[0]]
];

if (_dir < 0) then {
	_dir = random 360;
};

private _pos = _center getPos [floor (random ((_max - _min) + 1)) + _min, _dir];
_pos = AGLToASL _pos;

if !([_pos,_dist,_water,_gradient] call FUNC(isPosSafe)) then {
    _pos = _center;
};

_pos
