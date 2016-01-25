/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/22/2015

Description: finds random position

Note: return is positionASL

Return: array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_center","_min","_max","_checkDist","_dir","_range","_pos"];

_center = param [0,[],[[]]];
_min = param [1,0,[0]];
_max = param [2,100,[0]];
_checkDist = param [3,0];
_dir = param [4,-1];

if (_dir isEqualTo -1) then {
	_dir = random 360;
};

_range = floor (random ((_max - _min) + 1)) + _min;
_pos = [(_center select 0) + (sin _dir) * _range, (_center select 1) + (cos _dir) * _range];
_pos = _pos isFlatEmpty [_checkDist,0,1,10,1,false,objNull]; // returns positionASL
if (_pos isEqualTo []) exitWith {_center};
if (floor (_pos select 2) < 0) then {
	_pos set [2,0];
};

_pos