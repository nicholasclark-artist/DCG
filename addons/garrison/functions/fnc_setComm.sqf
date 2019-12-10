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

        for "_i" from 0 to 9 do {
            _polygonPositions pushBack ([_value getVariable [QEGVAR(main,polygon),[]]] call EFUNC(main,polygonRandomPos));
        };

        // find suitable position
        _polygonPositions = _polygonPositions select ([_x,0,0,0.275] call EFUNC(main,isPosSafe));

        // exit if no positions left
        if (_polygonPositions isEqualTo []) then {
            breakTo SCOPE;
        };
        
        // set as comms array location
        _value setVariable [QGVAR(positionASLComm),selectRandom _polygonPositions];

        // update score
        [QGVAR(updateScore),[_location,COMM_SCORE]] call CBA_fnc_localEvent;
    };
}] call CBA_fnc_hashEachPair;

nil