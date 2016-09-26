/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a position of a certain terrain type. If the terrain type is "house", the function returns an array including the house object and position

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>
2: terrain type <STRING>
3: safe position distance check <NUMBER>
4: find rural position <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST 500
#define DIST_HOUSE 100
#define GRAD 0.275

params [
	"_anchor",
	"_range",
	["_terrain",""],
	["_check",0],
	["_rural",false]
];

private _ret = [];
private _expression = "";

call {
	if (toLower _terrain isEqualTo "meadow") exitWith {
		_expression = "(1 + meadow) * (1 - forest) * (1 - sea)";
	};
	if (toLower _terrain isEqualTo "forest") exitWith {
		_expression = "(1 + forest + trees) * (1 - sea)";
	};
	if (toLower _terrain isEqualTo "house") exitWith {
		_expression = "(1 + houses) * (1 - sea)";
	};
	if (toLower _terrain isEqualTo "hill") exitWith {
		_expression = "(1 + hills) * (1 - sea)";
	};
};

if (_terrain isEqualTo "" || {_expression isEqualTo ""}) exitWith {
	LOG_DEBUG("Cannot find position. Expression is empty.");
};

private _places = selectBestPlaces [_anchor,_range,_expression,100,20];

_places = if !(_rural) then {
	_places select {(_x select 1) > 0 && {!(CHECK_DIST2D((_x select 0),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))}};
} else {
	_places select {(_x select 1) > 0 && {((nearestLocations [(_x select 0), ["NameVillage","NameCity","NameCityCapital"], DIST]) isEqualTo [])} && {!(CHECK_DIST2D((_x select 0),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius)))}};
};

{
	private _pos = _x select 0;
	_pos set [2,getTerrainHeightASL _pos];

	if !(_terrain isEqualTo "house") then {
		if (_check > 0 && {!([_pos,_check,0,GRAD] call FUNC(isPosSafe))}) exitWith {};
		_ret = _pos;
	} else {
		_ret = [_pos,DIST_HOUSE] call FUNC(findPosHouse);
	};

	if !(_ret isEqualTo []) exitWith {};
} forEach _places;

_ret