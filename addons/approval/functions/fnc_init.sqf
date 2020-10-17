/*
Author:
Nicholas Clark (SENSEI)

Description:
init approval addon

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define DEFAULT_VARIANCE AP_DEFAULT*0.333

[EGVAR(main,locations),{
    // set starting approval value
    private _min = AP_DEFAULT - DEFAULT_VARIANCE;
    private _max = AP_DEFAULT + DEFAULT_VARIANCE;

    _value setVariable [QGVAR(value),[_min,_max] call BIS_fnc_randomNum];

    // set default color
    _value setVariable [QGVAR(color),DEFAULT_COLOR];

    // update region color
    [_value getVariable [QEGVAR(main,positionASL),DEFAULT_POS],0] call FUNC(setValue);
}] call CBA_fnc_hashEachPair;

nil