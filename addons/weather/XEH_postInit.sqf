/*
Author:
Nicholas Clark (SENSEI)
__________________________________________________________________*/
#include "script_component.hpp"
#define SUMMER [6,7,8]
#define FALL [9,10,11]
#define WINTER [12,1,2]
#define SPRING [3,4,5]
#define MORNING [5,6,7,8,9,10,11]
#define MIDDAY [12,13,14,15]
#define EVENING [16,17,18,19]
#define NIGHT [20,21,22,23,0,1,2,3,4]

if (!isServer || !isMultiplayer) exitWith {};

if (GVAR(enable) isEqualTo 0) exitWith {
	LOG_DEBUG("Addon is disabled.");
};

[{
	if (DOUBLES(PREFIX,main)) exitWith {
		[_this select 1] call CBA_fnc_removePerFrameHandler;

		private ["_overcast","_date","_month","_hour"];
		_data = QUOTE(ADDON) call EFUNC(main,loadDataAddon);
		if (_data isEqualTo []) then {
			if (GVAR(season) isEqualTo -1) then {
				GVAR(season) = ([0,1,2,3] select floor (random (count [0,1,2,3])));
			};
			call {
				if (GVAR(season) isEqualTo 1) exitWith {_month = (FALL select floor (random (count FALL)))};
				if (GVAR(season) isEqualTo 2) exitWith {_month = (WINTER select floor (random (count WINTER)))};
				if (GVAR(season) isEqualTo 3) exitWith {_month = (SPRING select floor (random (count SPRING)))};
				_month = (SUMMER select floor (random (count SUMMER)));
			};

			if (GVAR(time) isEqualTo -1) then {
				GVAR(time) = ([0,1,2,3] select floor (random (count [0,1,2,3])));
			};
			call {
				if (GVAR(time) isEqualTo 1) exitWith {_hour = (MIDDAY select floor (random (count MIDDAY)))};
				if (GVAR(time) isEqualTo 2) exitWith {_hour = (EVENING select floor (random (count EVENING)))};
				if (GVAR(time) isEqualTo 3) exitWith {_hour = (NIGHT select floor (random (count NIGHT)))};
				_hour = (MORNING select floor (random (count MORNING)));
			};
			_overcast = ((GVAR(mapData) select (_month - 1)) + random 0.1) min 1;
			_date = [2016, _month, ceil random 27, _hour, 00];
		} else {
			_overcast = _data select 0;
			_date = _data select 1;
		};

		setDate _date;
		[[_overcast],{
			waitUntil {time > 5};
			(_this select 0) call BIS_fnc_setOvercast;
		}] remoteExec ["BIS_fnc_call",0,true];
	};
}, 0, []] call CBA_fnc_addPerFrameHandler;

ADDON = true;