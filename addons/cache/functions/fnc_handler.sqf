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
	private ["_units","_grpUnits"];
	_units = [];

	// get groups to cache
	{
		GVAR(groups) pushBack _x;
		[leader _x] call FUNC(leaderEH);
		_grpUnits = ((units _x) - [leader _x]);
		_units append _grpUnits;
	} forEach (call FUNC(getGroups));

	// cache units
	{
		[_x] call FUNC(cache);
	} forEach _units;

	// cached groups
	{
		if (isNull _x) then {
			GVAR(groups) deleteAt _forEachIndex;
		} else { // TODO check for AI as well
			// uncache units
			if (_x getVariable [CACHE_DISABLE_VAR,false] || {!(([leader _x,GVAR(dist)] call EFUNC(main,getNearPlayers)) isEqualTo [])}) exitWith {
				_units = (units _x) - [leader _x];
				{
					[_x] call FUNC(uncache);
				} forEach _units;
				GVAR(groups) deleteAt _forEachIndex;
			};
			// cache new units in cached group
			{
				if (!(_x isEqualTo leader _x) && {simulationEnabled _x}) then {
					[_x] call FUNC(cache);
				};
			} forEach (units _x);
		};
	} forEach GVAR(groups);
}, 15, []] call CBA_fnc_addPerFrameHandler;