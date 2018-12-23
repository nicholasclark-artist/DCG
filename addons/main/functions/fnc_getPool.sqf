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
    [GVAR(unitPoolEast),GVAR(vehPoolEast),GVAR(airPoolEast)] select _type;
};

if (_side isEqualTo WEST) exitWith {
    [GVAR(unitPoolWest),GVAR(vehPoolWest),GVAR(airPoolWest)] select _type;
}; 

if (_side isEqualTo INDEPENDENT) exitWith {
    [GVAR(unitPoolInd),GVAR(vehPoolInd),GVAR(airPoolInd)] select _type;
}; 

if (_side isEqualTo CIVILIAN) exitWith {
    [GVAR(unitPoolCiv),GVAR(vehPoolCiv),GVAR(airPoolCiv)] select _type;
}; 