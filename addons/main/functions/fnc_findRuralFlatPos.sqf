/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a flat rural position

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define EXPRESSION "(1 - forest) * (2 + meadow) * (1 - sea) * (1 - houses) * (1 - hills)"
#define DIST 2000

private ["_ret"];
params ["_anchor","_range"];

_ret = [];

{
	_pos = _x select 0;
	_locations = nearestLocations [_pos, ["NameVillage","NameCity","NameCityCapital"], DIST];
	if (_locations isEqualTo []) then {
		if !(_pos isFlatEmpty [2,0,0.3,15,0,false,objNull] isEqualTo [] && _pos isFlatEmpty [2,0,0.12,100,0,false,objNull] isEqualTo []) exitWith {
			_ret = _pos;
		};
	};
} forEach (selectBestPlaces [_anchor,_range,EXPRESSION,70,10]);

_ret