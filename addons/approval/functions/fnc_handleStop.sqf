/*
Author:
Nicholas Clark (SENSEI)

Description:
handle stopping unit

Arguments:
0: player stopping unit <OBJECT>
1: unit <OBJECT>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params ["_player","_target"];

_target disableAI "MOVE";
_target setDir (_target getDir _player);

// @todo find better way to globally signal that unit is stopped
_target setVariable [QGVAR(isStopped),true,true];

[
    {
        _this enableAI "MOVE";
        _this setVariable [QGVAR(isStopped),nil,true];
    },
    _target,
    15
] call CBA_fnc_waitAndExecute;

nil