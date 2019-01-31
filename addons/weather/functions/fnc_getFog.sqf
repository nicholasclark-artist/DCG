/*
Author:
Nicholas Clark (SENSEI)

Description:
get fog value

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private _diff = GVAR(temperatureCurrent) - (call FUNC(getDewPoint));

TRACE_1("",_diff);

private _fog = if (_diff < 2.5) then {
    random [0,0.2,0.6] - _diff * 0.11;
} else {
    0
};

_fog = 0 max _fog min 1;

[_fog, _fog/10 + random _fog/100, random 100]