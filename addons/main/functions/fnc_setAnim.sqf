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

(_this select 0) playMoveNow (_this select 1);

/*if !(animationState (_this select 0) isEqualTo (_this select 1)) then {
	(_this select 0) switchMove (_this select 1);
};*/