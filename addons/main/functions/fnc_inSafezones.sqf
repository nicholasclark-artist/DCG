/*
Author:
Nicholas Clark (SENSEI)

Description:
check if position or entity is in any safezone area

Arguments:
0: entity to check <ARRAY,OBJECT,GROUP,LOCATION,MARKER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(inSafezones)

params [
    ["_entity",objNull,[objNull,grpNull,locationNull,"",[]]]
];

scopeName SCOPE;

// @todo optimize array case
switch (typeName _entity) do {
    case "ARRAY" : {
        if ((_entity select 0) isEqualType 0) then {
            _entity = [_entity];
        };

        {
            private ["_inSafezone", "_currentEntity"];
            _currentEntity = _x;

            if !(_currentEntity isEqualType []) then {
                _inSafezone = [_currentEntity] call FUNC(inSafezones);
            } else {
                _inSafezone = GVAR(safezoneTriggers) findIf {_currentEntity inArea _x} > -1
            };

            if (_inSafezone) exitWith {true breakOut SCOPE};
        } forEach _entity;

        false
    };
    case "OBJECT" : {
        GVAR(safezoneTriggers) findIf {_entity inArea _x} > -1
    };
    case "GROUP" : {
        GVAR(safezoneTriggers) findIf {getPos leader _entity inArea _x} > -1
    };
    case "LOCATION" : {
        GVAR(safezoneTriggers) findIf {locationPosition _entity inArea _x} > -1
    };
    case "STRING" : {
        GVAR(safezoneTriggers) findIf {getMarkerPos _entity inArea _x} > -1
    };
    default {false};
};