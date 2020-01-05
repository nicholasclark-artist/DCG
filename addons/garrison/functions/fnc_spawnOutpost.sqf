/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn outposts,should not be called directly

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnOutpost)

// @todo spawn intel files on composition node 
// @todo disallow water waypoints

// define scope to break hash loop
scopeName SCOPE;

[GVAR(outposts),{
    // get composition type
    private _terrain = (_value getVariable [QGVAR(terrain),""]) call {
        if (COMPARE_STR(_this,"meadow")) exitWith {"mil_cop"};
        if (COMPARE_STR(_this,"peak")) exitWith {"mil_pb"};
        if (COMPARE_STR(_this,"forest")) exitWith {"mil_pb"};

        ""
    };

    // spawn outpost for certain terrain type
    private _composition = [_value getVariable [QGVAR(positionASL),DEFAULT_SPAWNPOS],_terrain,random 360,true] call EFUNC(main,spawnComposition);
    
    if (_composition isEqualTo []) then {
        breakTo SCOPE;
    };

    // setvars 
    _value setVariable [QGVAR(radius),_composition select 0];
    _value setVariable [QGVAR(nodes),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];
    
    // spawn infantry
    [_value] call FUNC(spawnUnit);
}] call CBA_fnc_hashEachPair;

nil