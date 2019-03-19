/*
Author:
Nicholas Clark (SENSEI)

Description:
add to cleanup loop

Arguments:
0: entity <ARRAY, STRING, OBJECT, LOCATION, GROUP>

Return:
nothing
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
            _x call FUNC(cleanup);
            WARNING_1("multi-dimensional array passed to %1",QGVAR(cleanup))
        };
    } forEach _entity;
} else {
    GVAR(cleanup) pushBack _entity;
};

nil