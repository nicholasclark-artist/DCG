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

// setup patrols 
for "_i" from 0 to ((_location getVariable [QGVAR(unitCount),0]) - 1) do {
    // get random house position
    _position = selectRandom (selectRandom (_location getVariable [QGVAR(buildingPositions),[]]));

    _agent = createAgent [selectRandom EGVAR(main,unitsCiv),DEFAULT_SPAWNPOS,[],0,"CAN_COLLIDE"];
    _agent setPosATL _position;

    // init code
    _agent call (_location getVariable [QGVAR(onCreate),{}]);
    _agent addEventHandler ["Deleted", _location getVariable [QGVAR(onDelete),{}]]; 

    // panic event
    // @todo add panic check for unit approval questioning
    _agent addEventHandler ["FiredNear", {
        params ["_unit", "_firer", "_distance"];

        if !(_unit getVariable [QGVAR(panic),false]) then {
            _unit setVariable [QGVAR(panic),true];
            _unit forceSpeed (_unit getSpeed "FAST");
            // _unit playAction "Crouch";

            _buildingPositions = nearestBuilding _unit buildingPos -1;

            if !(_buildingPositions isEqualTo []) then {
                _unit moveTo (selectRandom _buildingPositions);
            } else {
                _unit moveTo (_position getPos [_radius, random 360]);
            };

            [
                {
                    if (alive (_this select 0)) then {
                        (_this select 0) setVariable [QGVAR(panic),false];
                    };  
                },
                [_unit],
                180
            ] call CBA_fnc_waitandExecute;
        };  
    }];

    // patrol units
    [FUNC(handlePatrol), 60, [_agent,_location]] call CBA_fnc_addPerFrameHandler;

    _units pushBack _agent;
};

// save reference to all units in location
_location setVariable [QGVAR(units),_units];

nil