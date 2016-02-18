/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer || !isMultiplayer) exitWith {};

[{
	if (DOUBLES(PREFIX,main) && {time > 45}) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		// actions
		{
			if (hasInterface) then {
				// fix "respawn on start" missions
				_time = diag_tickTime;
				waitUntil {diag_tickTime > _time + 10 && {!isNull (findDisplay 46)} && {!isNull player} && {alive player}};
				[QUOTE(ADDON),"Tasks","","true","",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions))]] call EFUNC(main,setAction);
				[QUOTE(DOUBLES(ADDON,primary)),"Cancel Primary Task",QUOTE([1] call FUNC(cancel)),QUOTE(!(GVAR(primary) isEqualTo []) && {(isServer || serverCommandAvailable '#logout')}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]] call EFUNC(main,setAction);
				[QUOTE(DOUBLES(ADDON,secondary)),"Cancel Secondary Task",QUOTE([0] call FUNC(cancel)),QUOTE(!(GVAR(secondary) isEqualTo []) && {(isServer || serverCommandAvailable '#logout')}),"",player,1,["ACE_SelfActions",QUOTE(DOUBLES(PREFIX,actions)),QUOTE(ADDON)]] call EFUNC(main,setAction);
			};
		} remoteExec ["BIS_fnc_call",0,true];

		// load data
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if !(_data isEqualTo []) then {
			_data params ["_primary","_secondary"];

			if !(_primary isEqualTo []) then {
				_task = compile (_primary select 0);
				[_primary select 1] spawn _task;
			} else {
				[1,0] spawn FUNC(select);
			};

			if !(_secondary isEqualTo []) then {
				_task = compile (_secondary select 0);
				[_secondary select 1] spawn _task;
			} else {
				[0,10] spawn FUNC(select);
			};
		} else { // if previous data was saved without task addon
			[1,0] spawn FUNC(select);
			[0,10] spawn FUNC(select);
		};
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;