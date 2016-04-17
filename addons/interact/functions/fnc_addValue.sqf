/*
Author:
Nicholas Clark (SENSEI)

Description:
add amount to value

Arguments:
0: amount <NUMBER>

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(value) = ((GVAR(value) + ((_this select 0)*GVAR(multiplier))) min 100) max 0;
publicVariable QGVAR(value);