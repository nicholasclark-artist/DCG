/*
Author:
Nicholas Clark (SENSEI)

Description:
get region from position

Arguments:
0: positionASL <ARRAY>

Return:
location
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(getRegion)

params [
    ["_position",[],[[]]]
];

scopeName SCOPE;

[EGVAR(main,locations),{
    if (ASLtoAGL _position inPolygon (_value getVariable [QEGVAR(main,polygon),[]])) then {
        _value breakOut SCOPE;
    };
}] call CBA_fnc_hashEachPair;

locationNull