/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn units in settlement

Arguments:
0: spawn location <LOCATION>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_location",locationNull,[locationNull]]
];

private ["_units","_position"];

_units = [];

for "_i" from 0 to ((_location getVariable [QGVAR(unitCount),0]) - 1) do {
    // get random house position
    _position = selectRandom (selectRandom (_location getVariable [QGVAR(buildingPositions),[]]));

    _agent = createAgent [selectRandom EGVAR(main,unitsCiv),DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
    _agent setPosASL (AGLToASL _position); 

    // init code
    _agent call (_location getVariable [QGVAR(onCreate),{}]);
    _agent addEventHandler ["Deleted", _location getVariable [QGVAR(onDelete),{}]]; 

    // panic event
    // @todo add panic check for unit approval questioning
    _agent addEventHandler ["FiredNear", {
        params ["_unit", "_firer", "_distance"];

        if !(_unit getVariable [QGVAR(panic),false]) then {
            [QGVAR(panic),[_unit,1]] call CBA_fnc_localEvent;
        };  
    }];
    _units pushBack _agent;
};

// save reference to all units in location
_location setVariable [QGVAR(units),_units];

nil