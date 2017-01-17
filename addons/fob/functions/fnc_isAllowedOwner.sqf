/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player can handle FOB

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_player",objNull,[objNull]]
];

if (GVAR(allow) isEqualTo 0) exitWith {
    true
};

if (GVAR(allow) isEqualTo 1) exitWith {
    if (_player isEqualTo leader group _player) then {
        true
    } else {
        false
    };
};
