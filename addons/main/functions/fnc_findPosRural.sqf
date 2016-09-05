/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a rural position of a certain terrain type. If the terrain type is "house", the function returns an array including the house object and position

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>
2: terrain type <STRING>
3: check for flat terrain <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST 500

params [
	"_anchor",
	"_range",
	["_terrain",""],
	["_check",true]
];

private _ret = [];
private _expression = "";

call {
	if (toLower _terrain isEqualTo "meadow") exitWith {
		_expression = "(1 + meadow) * (1 - forest) * (1 - sea) * (1 - hills) * (1 - houses)";
	};
	if (toLower _terrain isEqualTo "forest") exitWith {
		_expression = "(1 + forest + trees) * (1 - sea)";
	};
	if (toLower _terrain isEqualTo "house") exitWith {
		_expression = "(1 + houses)";
	};
	if (toLower _terrain isEqualTo "hill") exitWith {
		_expression = "(1 + hills) * (1 - meadow)";
	};
};

if (_terrain isEqualTo "" || {_expression isEqualTo ""}) exitWith {
	LOG_DEBUG("Cannot find rural position. Expression is empty.");
};

private _places = selectBestPlaces [_anchor,_range,_expression,65,15];
_places = _places select {(_x select 1) > 0 && {((nearestLocations [(_x select 0), ["NameVillage","NameCity","NameCityCapital"], DIST]) isEqualTo [])} && {!(CHECK_DIST2D((_x select 0),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))}};

if !(_places isEqualTo []) then {
	private _pos = _places select 0 select 0;
	_pos set [2,getTerrainHeightASL _pos];

	if !(_terrain isEqualTo "house") then {
		if (_check) then {
			if ([_pos,5,0,0.275] call FUNC(isPosSafe)) then {
				_ret = _pos;
			};
		} else {
			_ret = _pos;
		};
	} else {
		_ret = [_pos,500] call FUNC(findPosHouse);
	};
};

_ret