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

// define scope to break hash loop
scopeName SCOPE;

private ["_intelNodes","_intelComp","_intelObj"];

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

    // spawn intel composition
    _intelNodes = (_composition select 1) select {((_x select 0) select 2) < 0.5};
    _intelComp = [selectRandom _intelNodes,""] call FUNC(spawnPrefab);

    // get intel object from composition
    {
        if (typeOf _x in INTEL_CLASSES) exitWith {
            _intelObj = _x;

            // @todo add action
        };
    } forEach (_intelComp select 2);

    // assign intel object
    if (GVAR(intelPrimary) isEqualTo []) then {
        GVAR(intelPrimary) pushBack _intelObj;
    } else {
        GVAR(intelSecondary) pushBack _intelObj;
    };

    // setvars 
    _value setVariable [QGVAR(radius),_composition select 0];
    _value setVariable [QGVAR(nodes),_composition select 1];
    _value setVariable [QGVAR(composition),_composition select 2];
    
    // spawn infantry
    // [_value] call FUNC(spawnUnit);
}] call CBA_fnc_hashEachPair;

nil