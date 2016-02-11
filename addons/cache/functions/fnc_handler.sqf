/*
Author:
Nicholas Clark (SENSEI)

Description:
handles group caching

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[{
	private ["_units","_grps","_grp"];
	_units = [];

	// get groups to cache
	_grps = call FUNC(getGroups);

	for "_i" from 0 to (count _grps - 1) do {
		_grp = _grps select _i;
		GVAR(groups) pushBack _grp;
		if !((leader _grp) getVariable [QUOTE(DOUBLES(ADDON,leaderHasEH)),false]) then {
			[leader _grp] call FUNC(leaderEH);
		};
		_units = units _grp;
		_units = _units select {!(_x isEqualTo leader _x)};
	};

	// cache units
	if !(_units isEqualTo []) then {
		for "_i" from 0 to (count _units - 1) do {
			[_units select _i] call FUNC(cache);
		};
	};

	// cached groups
	GVAR(groups) = GVAR(groups) select {!isNull _x}; // remove null elements
	for "_i" from (count GVAR(groups) - 1) to 0 step -1 do {
		_grp = GVAR(groups) select _i;
		if ([_grp] call FUNC(canUncache)) exitWith {
			_units = units _grp;
			_units = _units select {!(_x isEqualTo leader _x)};
			{
				[_x] call FUNC(uncache);
			} forEach _units;
			GVAR(groups) deleteAt _i;
		};

		// cache new units in cached group
		{
			if (!(_x isEqualTo leader _x) && {simulationEnabled _x}) then {
				[_x] call FUNC(cache);
			};
		} forEach (units _grp);
	};
}, 15, []] call CBA_fnc_addPerFrameHandler;