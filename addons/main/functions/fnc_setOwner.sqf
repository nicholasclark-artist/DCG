/*
Author:
Nicholas Clark (SENSEI)

Description:
transfer entity to a requested owner

Arguments:
0: entity to transfer <OBJECT,GROUP,ARRAY>
1: machine id to receive entity <NUMBER>

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"

if (!isServer) exitWith {};

params [
    ["_entity",objNull,[objNull,grpNull,[]]],
    ["_id",2,[0]]
];

switch (toUpper typeName _entity) do {
    case "ARRAY": {
        {
            [_x,_id] call FUNC(setOwner);
        } forEach _entity;
    };
    case "OBJECT": {
        if !(isNull group _entity) then {
            group _entity setGroupOwner _id;
            TRACE_2("transfer group",group _entity,_id);
        } else {
            _entity setOwner _id;
            TRACE_2("transfer object",_entity,_id);
        };
    };
    case "GROUP": {
        _entity setGroupOwner _id;
        TRACE_2("transfer group",_entity,_id);
    };
    default { };
};

nil