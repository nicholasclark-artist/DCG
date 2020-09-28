/*
Author:
Nicholas Clark (SENSEI)

Description:
display CBA notification with sound

Arguments:
0: notify params <ARRAY,STRING>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

_this call CBA_fnc_notify;

playSound "hint";

nil