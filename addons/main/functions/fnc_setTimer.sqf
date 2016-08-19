/*
Author:
Nicholas Clark (SENSEI)

Description:
set timer

Arguments:
0: countdown timer <NUMBER>
1: hint interval <NUMBER>
2: hint title <STRING>
3: timer complete code <CODE>
4: timer complete code arguments <ANY>
5: machines to run timer on <NUMBER,OBJECT,SIDE,GROUP,ARRAY>
6: JIP id <BOOL>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
	"_time",
	["_interval",60],
	["_title",format ["%1 Timer", toUpper QUOTE(PREFIX)]],
	["_code",{}],
	["_params",[]],
	["_target",0],
	["_jip",false]
];

[[_time,_interval,_title,_code,_params],{
	_this params ["_time","_interval","_title","_code","_params"];

 	GVAR(exitTimer) = false;
 	GVAR(timer) = _time;

 	[{
 		params ["_args","_idPFH"];
 		_args params ["_time","_interval","_title","_code","_params"];

 		if (GVAR(exitTimer)) exitWith {
 			[_idPFH] call CBA_fnc_removePerFrameHandler;
 		};

 		if (GVAR(timer) < 1) exitWith {
 			[_idPFH] call CBA_fnc_removePerFrameHandler;
 			_params = [_time] + _params;
 			_params call _code;
 		};

 		if ((GVAR(timer)/_interval) mod 1 isEqualTo 0) then {
	 		_format = "";
			_hour = str(floor(GVAR(timer) / 3600));
			_min = str(floor((GVAR(timer) - (floor(GVAR(timer) / 3600) * 3600)) / 60));
			_sec = str(GVAR(timer) - (floor(GVAR(timer) / 3600) * 3600) - (floor((GVAR(timer) - (floor(GVAR(timer) / 3600) * 3600)) / 60) * 60));

			if (count _hour isEqualTo 1) then {
				_hour = format ["0%1",_hour];
			};
			if (count _min isEqualTo 1) then {
				_min = format ["0%1",_min];
			};
			if (count _sec isEqualTo 1) then {
				_sec = format ["0%1",_sec];
			};

			if (_hour isEqualTo "00") then {
				_format = format ["%1:%2",_min,_sec];
			} else {
				_format = format ["%1:%2:%3",_hour,_min,_sec];
			};

			[format ["%1\n%2", _title,_format],false] call FUNC(displayText);
		};

		GVAR(timer) = GVAR(timer) - 1;
 	}, 1, [_time,_interval,_title,_code,_params]] call CBA_fnc_addPerFrameHandler;
}] remoteExecCall ["BIS_fnc_call",_target,_jip];

true