/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if !(CHECK_INIT) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main) && {time > 15}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		GVAR(primaryBlacklist) = GVAR(primaryBlacklist) apply {toLower _x};
		GVAR(secondaryBlacklist) = GVAR(secondaryBlacklist) apply {toLower _x};

		GVAR(primaryList) = GVAR(primaryList) select {!(toLower _x in GVAR(primaryBlacklist))};
		GVAR(secondaryList) = GVAR(secondaryList) select {!(toLower _x in GVAR(secondaryBlacklist))};

		LOG_DEBUG_2("Prim: %1, Sec: %2",GVAR(primaryList),GVAR(secondaryList));

		[
			{!isNull player && {alive player}},
			{
				{
					_x call EFUNC(main,setAction);
				} forEach [
					[QUOTE(ADDON),"Tasks","","true",""],
					[QUOTE(DOUBLES(ADDON,primary)),"Cancel Primary Task",QUOTE([1] call FUNC(cancel)),QUOTE(isServer || serverCommandAvailable '#logout'),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]],
					[QUOTE(DOUBLES(ADDON,secondary)),"Cancel Secondary Task",QUOTE([0] call FUNC(cancel)),QUOTE(isServer || serverCommandAvailable '#logout'),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]]
				];
			}
		] remoteExecCall [QUOTE(CBA_fnc_waitUntilAndExecute), 0, true];

		// load data
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			_data params ["_primary","_secondary"];

			if !(_primary isEqualTo []) then {
				[_primary select 1] spawn (missionNamespace getVariable [_primary select 0,{}]);
			} else {
				[1,0] call FUNC(select);
			};

			if !(_secondary isEqualTo []) then {
				[_secondary select 1] spawn (missionNamespace getVariable [_secondary select 0,{}]);
			} else {
				[0,10] call FUNC(select);
			};
		} else { // if previous data was saved without task addon
			[1,0] call FUNC(select);
			[0,10] call FUNC(select);
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;