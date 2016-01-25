/*
Author: Killzone Kid, SENSEI

Last modified: 12/14/2015

Description: check if in building

Return: array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_pos","_ignore","_house"];

if (typeName _this isEqualTo "OBJECT") then {
	_pos = getPosWorld _this;
	_ignore = _this;
} else {
	_pos = AGLToASL _this;
	_ignore = objNull;
};
lineIntersectsSurfaces [
	_pos,
	_pos vectorAdd [0, 0, 50],
	_ignore, objNull, true, 1, "GEOM", "NONE"
] select 0 params ["","","","_house"];

if (_house isKindOf "House") exitWith {true};

false