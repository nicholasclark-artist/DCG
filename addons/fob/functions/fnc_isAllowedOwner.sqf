/*
Author:
Nicholas Clark (SENSEI)

Description:
check if player can handle FOB

Arguments:

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

_player = _this select 0;

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
