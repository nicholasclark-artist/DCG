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
#define DEFAULT_POLYGON_COLOR [0,0,0,1]

// create region hash
// KVP: ["",[]], value: [position, approval value, polygon, polygon color]
GVAR(regions) = ([EGVAR(main,locations)] call CBA_fnc_hashKeys) apply {[_x,[]]};
GVAR(regions) = [GVAR(regions)] call CBA_fnc_hashCreate;

// load saved data
private _data = [QUOTE(ADDON)] call EFUNC(main,loadDataAddon);

// populate hash values
private ["_newValue","_position","_dataKey","_min","_max","_polygon","_index"];

[GVAR(regions),{
    _newValue = [];

    // get region position from location hash
    _position = ([EGVAR(main,locations),_key] call CBA_fnc_hashGet) select 0;
    _newValue pushBack _position;
    
    // get approval value from saved data
    if !(_data isEqualTo []) then {
        _index = ([GVAR(regions)] call CBA_fnc_hashKeys) find _key; 
        _dataKey = (_data select _index select 0);

        // data key and region key must be the same
        if ([GVAR(regions),_dataKey] call CBA_fnc_hashHasKey) then {
            _newValue pushBack (_data select _index select 1);
        };
    } else {
        _min = AP_DEFAULT - DEFAULT_VARIANCE;
        _max = AP_DEFAULT + DEFAULT_VARIANCE;

        _newValue pushBack ((random (_max - _min)) + _min);
    };

    // get region polygon from polygon hash
    _polygon = [EGVAR(main,locationPolygons),_key] call CBA_fnc_hashGet;
    _newValue pushBack _polygon;

    // push default polygon color
    _newValue pushBack DEFAULT_POLYGON_COLOR;

    // update region hash value
    [GVAR(regions),_key,_newValue] call CBA_fnc_hashSet;

    // update region color
    [_position,0] call FUNC(addValue);
}] call CBA_fnc_hashEachPair;

// start hostile handler after one cooldown cycle
[{
    [FUNC(handleHostile), GVAR(hostileCooldown), []] call CBA_fnc_addPerFrameHandler;
}, [], GVAR(hostileCooldown)] call CBA_fnc_waitAndExecute;

nil