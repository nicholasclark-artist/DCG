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

// load saved data
private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

// populate hash values
private ["_newValue","_position","_dataKey","_min","_max","_polygon","_index"];

[EGVAR(main,locations),{
    // get approval value from saved data
    if !(_data isEqualTo []) then {
        // _index = ([GVAR(regions)] call CBA_fnc_hashKeys) find _key; 
        // _dataKey = (_data select _index select 0);

        // // data key and region key must be the same
        // if ([GVAR(regions),_dataKey] call CBA_fnc_hashHasKey) then {
        //     _newValue pushBack (_data select _index select 1);
        // };
    } else {
        // set starting approval value
        _min = AP_DEFAULT - DEFAULT_VARIANCE;
        _max = AP_DEFAULT + DEFAULT_VARIANCE;

        _value setVariable [QGVAR(value),(random (_max - _min)) + _min];
    };

    // set default color
    _value setVariable [QGVAR(color),DEFAULT_COLOR];

    // update region color
    [_value getVariable [QEGVAR(main,positionASL),DEFAULT_POS],0] call FUNC(setValue);
}] call CBA_fnc_hashEachPair;

// start hostile handler after one cooldown cycle
[{
    [FUNC(handleHostile),GVAR(hostileCooldown),[]] call CBA_fnc_addPerFrameHandler;
},[],GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

nil