/*
Author:
Nicholas Clark (SENSEI)

Description:
set comm array locations

Arguments:

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setComm)

// define scope to break hash loop
scopeName SCOPE;

private ["_polygonPositions"];

[GVAR(areas),{
    // only run on active garrison
    if (_value getVariable [QGVAR(activeGarrison),0] isEqualTo 1) then {
        // get random positions in polygon
        _polygonPositions = [];

        for "_i" from 0 to 4 do {
            _polygonPositions pushBack ([_value getVariable [QEGVAR(main,polygon),[]]] call EFUNC(main,polygonRandomPos));
        };
    };
}] call CBA_fnc_hashEachPair;

nil