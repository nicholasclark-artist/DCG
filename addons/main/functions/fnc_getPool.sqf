/*
Author:
Nicholas Clark (SENSEI)

Description:
get unit pool 

Arguments:
0: side <SIDE>
1: type <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    "_side",
    ["_type",0,[0]]
];

if (_side isEqualTo EAST) exitWith {
    [GVAR(unitsEast),GVAR(vehiclesEast),GVAR(aircraftEast),GVAR(officersEast),GVAR(snipersEast)] select _type;
};

if (_side isEqualTo WEST) exitWith {
    [GVAR(unitsWest),GVAR(vehiclesWest),GVAR(aircraftWest),GVAR(officersWest),GVAR(snipersWest)] select _type;
}; 

if (_side isEqualTo INDEPENDENT) exitWith {
    [GVAR(unitsInd),GVAR(vehiclesInd),GVAR(aircraftInd),GVAR(officersInd),GVAR(snipersInd)] select _type;
}; 

if (_side isEqualTo CIVILIAN) exitWith {
    [GVAR(unitsCiv),GVAR(vehiclesCiv),GVAR(aircraftCiv),[],[]] select _type;
}; 