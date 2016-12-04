/*
Author:
Nicholas Clark (SENSEI)

Description:
find grid of positions (positionASL)

Arguments:
0: center position <ARRAY>
1: distance between positions <NUMBER>
2: max distance from center <NUMBER>
3: min distance from center <NUMBER>
4: min distance from objects <NUMBER>
5: allow water <BOOL>
6: shuffle position array <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define POS_COUNT floor (_range/_dist)
#define ANCHOR_OFFSET [(_anchor select 0) - (_range/2),(_anchor select 1) - (_range/2)]
#ifdef DEBUG_MODE_FULL
  #define GRID_DEBUG true
#else
  #define GRID_DEBUG false
#endif

private ["_ret","_retTemp","_fnc_createRow"];
params [
	"_anchor",
	["_dist",25,[0]],
	["_range",100,[0]],
	["_rangeMin",0,[0]],
	["_distObj",-1,[0]],
	["_water",false],
	["_shuffle",true]
];

_retTemp = [];
_ret = [];

_fnc_createRow = {
	private ["_ret"];
	params ["_anchor","_range"];

	_ret = [];
	for "_i" from 0 to POS_COUNT do {
		_ret pushBack [(_anchor select 0) + (_range*(_i/POS_COUNT)), _anchor select 1];
	};

	_ret
};

for "_i" from 0 to POS_COUNT do {
	_retTemp append ([[ANCHOR_OFFSET select 0,(ANCHOR_OFFSET select 1) + (_range*(_i/POS_COUNT))],_range] call _fnc_createRow);
};

{
	private ["_posASL","_check","_pos"];
	_check = true;
	_pos = _x;

	if !(_water) then {
		if (surfaceIsWater _pos) then {
			_check = false;
		};
	};

	if (_pos distance2D _anchor < _rangeMin) then {
		_check = false;
	};

	if (_check) then {
		_posASL = _pos isFlatEmpty [_distObj,-1,-1,1,-1];
		if !(_posASL isEqualTo []) then {
			if (floor (_posASL select 2) < 0) then {
				_posASL set [2,0];
			};
			_ret pushBack _posASL;
		};
	};
} forEach _retTemp;

if (SHOW_DEBUG) then {
	{
		_mrk = createMarker [format ["%1", _x], _x];
		_mrk setMarkerType "mil_dot";
		_mrk setMarkerText str (_x select 2);
	} forEach _ret;
};

if (_shuffle) then {
	[_ret,(count _ret)*3] call FUNC(shuffle);
};

_ret
