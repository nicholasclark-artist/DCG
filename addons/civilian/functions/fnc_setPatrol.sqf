/*
Author:
Nicholas Clark (SENSEI)

Description:
set patrol

Arguments:
0: unit <OBJECT>
1: center position for patrol <ARRAY>
2: patrol range <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_unit",objNull,[objNull]],
    ["_center",[0,0,0],[[]]],
    ["_range",100,[0]]
];

_unit forceSpeed (_unit getSpeed "SLOW");

_idPFH = [{
    params ["_args","_idPFH"];
    _args params ["_unit","_center","_range"];

    if !(alive _unit) exitWith {
        [_idPFH] call CBA_fnc_removePerFrameHandler;
    };

    if (unitReady _unit) then {
        _pos = _center getPos [_range, random 360];

        if !(surfaceIsWater _pos) then {
            _unit doMove _pos;
        };
    };
}, 15, [_unit,_center,_range]] call CBA_fnc_addPerFrameHandler;

_idPFH
