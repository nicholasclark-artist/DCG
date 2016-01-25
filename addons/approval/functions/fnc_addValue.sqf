/*
Author: Nicholas Clark (SENSEI)

Description:
add amount to value

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"

GVAR(value) = GVAR(value) + _this;
publicVariable QGVAR(value);