/*
Author:
Nicholas Clark (SENSEI)

Description:
find and occupy location

Arguments:
0: data loaded from server profile <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_data",[]]
];

if !(_data isEqualTo []) exitWith {
	{
		if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
			_x spawn FUNC(setOccupied);
		};
	} forEach _data;
};

private _locations = [];

{
	if !(CHECK_DIST2D((_x select 1),locationPosition EGVAR(main,baseLocation),EGVAR(main,baseRadius))) then {
		_locations pushBack _x;
	};
} forEach EGVAR(main,locations);

if (count _locations >= GVAR(locationCount)) then {
	[_locations,(count _locations)*3] call EFUNC(main,shuffle);

	for "_index" from 0 to (floor GVAR(locationCount)) - 1 do {
		(_locations select _index) spawn FUNC(setOccupied);
	};
};