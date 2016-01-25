/*
Author: Nicholas Clark (SENSEI)

Last modified: 12/20/2015

Description:
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main) && {time > 5}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		// load data
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			[{
				params ["_data","_idPFH"];

				if (count GVAR(groups) >= count _data) exitWith {
					[_idPFH] call CBA_fnc_removePerFrameHandler;
				};

				(_data select (count GVAR(groups))) params ["_pos","_count","_type"];
				_grp = [_pos,_type,_count] call EFUNC(main,spawnGroup);
				[units _grp,LAYER1_RANGE,false] call EFUNC(main,setPatrol);
				GVAR(groups) pushBack _grp;
			}, 5, _data] spawn CBA_fnc_addPerFrameHandler;
		};

		if (CHECK_HC) then {
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groups);
			(owner HEADLESSCLIENT) publicVariableClient QGVAR(groupsDynamic);
			remoteExecCall [QFUNC(PFH), owner HEADLESSCLIENT, false];
		} else {
			[] spawn FUNC(PFH);
		};

		if (CHECK_DEBUG) then {
			call FUNC(debug);
		};

		ADDON = true;
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

