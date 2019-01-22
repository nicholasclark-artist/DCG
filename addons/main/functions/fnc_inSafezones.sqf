/*
Author:
Nicholas Clark (SENSEI)

Description:
check if position or entity is in any safezone area

Arguments:
0: entity to check <ARRAY, OBJECT, GROUP, LOCATION, MARKER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_entity", objNull, [objNull, grpNull, locationNull, "", []]]
];

// @todo optimize array case 
switch (typeName _entity) do {
    case "ARRAY" : {
        if ((_entity select 0) isEqualType 0) then {
            _entity = [_entity];
        };

        {
            private ["_ret"];
            private _entity = _x;
            
            if !(_entity isEqualType []) then {
                _ret = [_entity] call FUNC(inSafezones);
            } else {
                _ret = (GVAR(safezoneTriggers) findIf {_entity inArea _x}) > -1
            };

            [false,true] select _ret;
        } forEach _entity;
    };
    case "OBJECT" : {
        (GVAR(safezoneTriggers) findIf {_entity inArea _x}) > -1
    };
    case "GROUP" : {
        (GVAR(safezoneTriggers) findIf {getPos leader _entity inArea _x}) > -1  
    };
    case "LOCATION" : {
        (GVAR(safezoneTriggers) findIf {locationPosition _entity inArea _x}) > -1
    };
    case "STRING" : {
        (GVAR(safezoneTriggers) findIf {getMarkerPos _entity inArea _x}) > -1 
    };
    default {};
};