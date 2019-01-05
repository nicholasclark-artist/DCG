/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit animation

Arguments:
0: unit <OBJECT>
1: animation <STRING>
2: animation priority <NUMBER>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_anim","",[""]],
    ["_priority",0,[0]]
];

call {
    if (_priority isEqualTo 0) exitWith {
        if (isNull objectParent _unit) then {
            _unit playMove _anim;
        } else {
            [_unit,_anim] remoteExecCall [QUOTE(playMove),0,false];
        };
    };

    if (_priority isEqualTo 1) exitWith {
        if (isNull objectParent _unit) then {
            _unit playMoveNow _anim;
        } else {
            [_unit,_anim] remoteExecCall [QUOTE(playMoveNow),0,false];
        };
    };

    if (_priority isEqualTo 2) exitWith {
        [_unit,_anim] remoteExecCall [QUOTE(switchMove),0,false];
    };
}
