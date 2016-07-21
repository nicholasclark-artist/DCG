/*
Author:
Nicholas Clark (SENSEI)

Description:
set unit animation

Arguments:
0: unit <OBJECT>
1: animation <STRING>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

if ((_this select 0) isEqualTo vehicle (_this select 0)) then {
    [QGVAR(playMoveNow), [(_this select 0), (_this select 1)], (_this select 0)] call CBA_fnc_targetEvent;
} else {
    [QGVAR(playMoveNow), [(_this select 0), (_this select 1)]] call CBA_fnc_globalEvent;
};

/*if !(animationState (_this select 0) isEqualTo (_this select 1)) then {
	(_this select 0) switchMove (_this select 1);
};*/