/*
Author:
Nicholas Clark (SENSEI)

Description:
handle intel items

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_intel",objNull,[objNull]],
    ["_type",0,[0]]
];

TRACE_1("",_this);

// get ao/outpost key associated with intel
private _key = _intel getVariable [QGVAR(intelKey),""];

switch _type do {
    case 0: { // secondary intel
        // @todo
        // mark enemy position
        // send msg to players
    };
    case 1: { // primary intel
        // cleanup intel area
        [_key] call FUNC(removeOutpost);
        [_key] call FUNC(removeArea);

        // init task phase
    };
    default {};
};