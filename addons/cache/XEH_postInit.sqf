/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	INFO("Addon is disabled.");
};

[{
	private ["_units","_grps","_grp"];

	_units = [];
	_grps = [];

	{
		if ([_x] call FUNC(canCache)) then {
			_grps pushBack _x;
		};
		false
	} count allGroups;

	for "_i" from 0 to (count _grps - 1) do {
		_grp = _grps select _i;

		[leader _grp] call FUNC(addEventhandler);
		_units = units _grp;
		_units = _units select {!(_x isEqualTo leader _x)};

		GVAR(groups) pushBack _grp;
	};

	if !(_units isEqualTo []) then {
		for "_i" from 0 to (count _units - 1) do {
			[_units select _i] call FUNC(cache);
		};
	};

	GVAR(groups) = GVAR(groups) select {!isNull _x}; // remove null elements

	for "_i" from (count GVAR(groups) - 1) to 0 step -1 do {
		_grp = GVAR(groups) select _i;

		if ([_grp] call FUNC(canUncache)) then {
			_units = units _grp;
			_units = _units select {!(_x isEqualTo leader _x)};
			{
				[_x] call FUNC(uncache);
			} forEach _units;

			GVAR(groups) deleteAt _i;
		} else {
			{
				if (!(_x isEqualTo leader _x) && {simulationEnabled _x}) then {
					[_x] call FUNC(cache);
				};
			} forEach (units _grp);
		};
	};
}, 15, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;