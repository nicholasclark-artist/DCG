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

// populate hash values
private ["_newValue","_position","_dataKey","_min","_max","_polygon","_index"];

[EGVAR(main,locations),{
    // set starting approval value
    _min = AP_DEFAULT - DEFAULT_VARIANCE;
    _max = AP_DEFAULT + DEFAULT_VARIANCE;

    _value setVariable [QGVAR(value),[_min,_max] call BIS_fnc_randomNum];

    // set default color
    _value setVariable [QGVAR(color),DEFAULT_COLOR];

    // update region color
    [_value getVariable [QEGVAR(main,positionASL),DEFAULT_POS],0] call FUNC(setValue);
}] call CBA_fnc_hashEachPair;

// start hostile handler after one cooldown cycle
// [{
//     [FUNC(handleHostile),GVAR(hostileCooldown),[]] call CBA_fnc_addPerFrameHandler;
// },[],GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

nil