/*
Author: Nicholas Clark (SENSEI), Killzone Kid

Last modified: 1/22/2016

Description: find and occupy location

Return: nothing
__________________________________________________________________*/
#include "script_component.hpp"

private ["_fnc_shuffle","_locations","_index"];

params [["_data",[]]];

if !(_data isEqualTo []) exitWith {
	{
		if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,mobLocation),EGVAR(main,mobRadius))) then {
			_x spawn FUNC(setOccupied);
		};
	} forEach _data;
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

_locations = [];

{
	if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,mobLocation),EGVAR(main,mobRadius))) then {
		_locations pushBack _x;
	};
	false
} count EGVAR(main,locations);

if (count _locations >= abs GVAR(locationCount)) then {
	[_locations,(count _locations)*3] call _fnc_shuffle;
	for "_index" from 0 to GVAR(locationCount) - 1 do {
		(_locations select _index) spawn FUNC(setOccupied);
	};
};