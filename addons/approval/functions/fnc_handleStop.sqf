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

[
    {_this enableAI "MOVE"},
    _target,
    15
] call CBA_fnc_waitAndExecute;

nil