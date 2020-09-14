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
    ["_type",0,[0]],
    ["_intel",objNull,[objNull]],
    ["_player",objNull[objNull]]
];

switch _type do {
    case 0: { // secondary intel
        // @todo
        // mark enemy position
        // send msg to players
    };
    case 1: { // primary intel
        // cleanup intel area
        [_key,_value] call FUNC(removeOutpost);
        [_key,_value] call FUNC(removeArea);

        // init task phase
    };
    default {};
};