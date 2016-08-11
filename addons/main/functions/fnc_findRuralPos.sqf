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
#define DIST (worldSize*0.04) max 500

private ["_ret","_expression","_pos"];
params [
	"_anchor",
	"_range",
	["_terrain",""],
	["_checkFlat",true]
];

_ret = [];
_expression = "";

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

if (_terrain isEqualTo "" || _expression isEqualTo "") exitWith {
	LOG_DEBUG("Cannot find rural position. Expression is empty.");
};

{
	_pos = _x select 0;
	if ((nearestLocations [_pos, ["NameVillage","NameCity","NameCityCapital"], DIST]) isEqualTo []) then {
		if !(_terrain isEqualTo "house") then {
			if (_checkFlat) then {
				if !(_pos isFlatEmpty [3,-1,0.27,40,0] isEqualTo []) then {
					_ret = _pos;
				};
			} else {
				_ret = _pos;
			};
		} else {
			_ret = [_pos,(DIST)*0.5] call FUNC(findHousePos);
		};

		if !(_ret isEqualTo []) exitWith {};
	};
} forEach (selectBestPlaces [_anchor,_range,_expression,100,30]);

_ret

