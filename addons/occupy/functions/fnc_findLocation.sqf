/*
Author:
Nicholas Clark (SENSEI), Killzone Kid

Description:
find and occupy location

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

private ["_locations","_index"];

params [["_data",[]]];

if !(_data isEqualTo []) exitWith {
	{
		if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
			_x spawn FUNC(setOccupied);
		};
	} forEach _data;
};

_locations = [];

{
	if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
		_locations pushBack _x;
	};
	false
} count EGVAR(main,locations);

if (count _locations >= abs GVAR(locationCount)) then {
	[_locations,(count _locations)*3] call EFUNC(main,shuffle);
	for "_index" from 0 to GVAR(locationCount) - 1 do {
		(_locations select _index) spawn FUNC(setOccupied);
	};
};