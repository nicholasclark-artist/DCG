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
5: machines to show timer on <NUMBER,OBJECT,SIDE,GROUP,ARRAY>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_time",
    ["_interval",60],
    ["_title",format ["%1 Timer", toUpper QUOTE(PREFIX)]],
    ["_code",{}],
    ["_params",[]],
    ["_target",0]
];

GVAR(timer) = _time;

_id = [{
    params ["_args","_idPFH"];
    _args params ["_time","_interval","_title","_code","_params","_target"];

    if (GVAR(timer) < 1) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
        _params = [_time] + _params;
        _params call _code;
    };

    if ((GVAR(timer)/_interval) mod 1 isEqualTo 0) then {
        _format = [GVAR(timer),"MM:SS",false] call BIS_fnc_secondsToString;
        [format ["%1\n%2", _title,_format],false] remoteExecCall [QFUNC(displayText),_target,false];
    };

    GVAR(timer) = GVAR(timer) - 1;
}, 1, [_time,_interval,_title,_code,_params,_target]] call CBA_fnc_addPerFrameHandler;

_id