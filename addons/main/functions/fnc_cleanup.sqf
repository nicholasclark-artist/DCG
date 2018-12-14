/*
Author:
Nicholas Clark (SENSEI)

Description:
add to cleanup loop, does not support nested arrays

Arguments:
0: entity <ARRAY, STRING, OBJECT, LOCATION, GROUP>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

[_this] params [
    ["_entity", objNull, [objNull, grpNull, locationNull, "", []]]
];

if (_entity isEqualType []) then {
    {
        if !(_x isEqualType []) then {
            GVAR(cleanup) pushBack _x;
        } else {
            _x spawn FUNC(cleanup);
            WARNING_1("Nested array passed to %1",QGVAR(cleanup))
        };
    } forEach _entity;
} else {
    GVAR(cleanup) pushBack _entity;
};
