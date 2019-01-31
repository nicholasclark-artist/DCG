/*
Author:
ACE2 Team, Nicholas Clark (SENSEI)

Description:
get current dew point

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"
#define __b 17.67
#define __c 243.5

if (GVAR(humidityCurrent) isEqualTo 0) exitWith {0};

private _gamma = ln(GVAR(humidityCurrent)) + (__b * GVAR(temperatureCurrent)) / (__c + GVAR(temperatureCurrent));

(__c * _gamma) / (__b - _gamma)