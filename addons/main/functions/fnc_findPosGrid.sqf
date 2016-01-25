/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/22/2015

Description: create grid of positions

Note: return is positionASL

Return: array
__________________________________________________________________*/
#include "script_component.hpp"
#define POS_COUNT floor (_range/_dist)
#define ANCHOR_OFFSET [(_anchor select 0) - (_range/2),(_anchor select 1) - (_range/2)]
#define SHOW_DEBUG false

private ["_ret","_retTemp","_fnc_createRow","_fnc_shuffle"];
params [
	"_anchor",
	["_dist",25,[0]],
	["_range",100,[0]],
	["_rangeMin",0,[0]],
	["_distObj",0,[0]],
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

_fnc_shuffle = {
    private ["_arr","_cnt"];
    _arr = _this select 0;
    _cnt = count _arr;
    for "_i" from 1 to (_this select 1) do {
        _arr pushBack (_arr deleteAt floor random _cnt);
    };
    _arr
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
		_posASL = _pos isFlatEmpty [_distObj,0,1,10,1,false,objNull];
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
	[_ret,(count _ret)*3] call _fnc_shuffle;
};

_ret