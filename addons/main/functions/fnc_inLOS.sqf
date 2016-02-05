/*
Author:
SENSEI

Description:
check if in position in line of sight

Arguments:
0: position to check <ARRAY>
1: unit to check line of sight for <OBJECT>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

private ["_pos","_unit","_posUnit","_ret"];

_pos = _this select 0;
_unit = _this select 1;

_posUnit = AGLToASL (_unit modelToWorld [0,0,3]);
_ret = true;

if ([getPosASL _unit,getDir _unit,90,_pos] call BIS_fnc_inAngleSector) then {
	if !(terrainIntersectASL [_pos, _posUnit]) then {
	    if (lineIntersects [_pos, _posUnit, _unit]) then {
	        _ret = false;
	    };
	} else {
	    _ret = false;
	};
} else {
	_ret = false;
};

_ret