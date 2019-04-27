/*
Author:
Nicholas Clark (SENSEI)

Description:


Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

// @todo reset namespace vars when players leave location 

// loop through all locations
[GVAR(locations),{
    // spawn entities if players in radius
    if (!(_value getVariable [QGVAR(active),false]) && {!([getPos _value,((size _value) select 0) + GVAR(spawnDist),_value getVariable [QGVAR(zdist),-1]] call EFUNC(main,getNearPlayers) isEqualTo [])}) then {
        // set location as active
        _value setVariable [QGVAR(active),true];

        [_value,"prefabs"] call FUNC(spawnAmbient);
        [_value,"parked"] call FUNC(spawnAmbient);

        // spawn units
        [_value] call FUNC(spawnUnit);

        // patrol handler
        [_value] call FUNC(handlePatrol);

        // cleanup when players leave area
        [{
            params ["_args","_idPFH"];
            _args params ["_value"];

            if ([getPos _value,((size _value) select 0) + GVAR(spawnDist),_value getVariable [QGVAR(zdist),-1]] call EFUNC(main,getNearPlayers) isEqualTo []) exitWith {
                [_idPFH] call CBA_fnc_removePerFrameHandler;
                
                // cleanup objects
                [QEGVAR(main,cleanup),_value getVariable [QGVAR(units),[]]] call CBA_fnc_serverEvent;
                [QEGVAR(main,cleanup),_value getVariable [QGVAR(ambients),[]]] call CBA_fnc_serverEvent;
                
                // reset vars
                _value setVariable [QGVAR(active),false];
                _value setVariable [QGVAR(moveToPositions),[]];
                _value setVariable [QGVAR(prefabPositions),[]];
                _value setVariable [QGVAR(ambients),[]];
                _value setVariable [QGVAR(units),[]];
            };
        }, 60, [_value]] call CBA_fnc_addPerFrameHandler;    
    };
}] call CBA_fnc_hashEachPair;

nil