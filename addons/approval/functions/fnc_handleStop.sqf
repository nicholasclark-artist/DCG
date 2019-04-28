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

_target moveTo (getPos _target);

if (_target getVariable [QEGVAR(civilian,patrol),true]) then {
    _target lookAt _player;
};

// @todo find better way to globally signal that unit is stopped
_target setVariable [QGVAR(isStopped),true,true];

[
    {
        _this setVariable [QGVAR(isStopped),nil,true];
        _this lookAt objNull;
    },
    _target,
    10
] call CBA_fnc_waitAndExecute;

nil