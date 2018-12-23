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
#define SAFEZONES GVAR(list)

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
            private "_ret";
            private _entity = _x;
            
            if !(_entity isEqualType []) then {
                _ret = [_entity] call FUNC(inAreaAll);
            } else {
                _ret = (SAFEZONES findIf {_entity inArea _x}) > -1
            };	

            if (_ret) exitWith {true};

            false
        } forEach _entity;
    };
    case "OBJECT" : {
        (SAFEZONES findIf {_entity inArea _x}) > -1
    };
    case "GROUP" : {
        (SAFEZONES findIf {getPos leader _entity inArea _x}) > -1  
    };
    case "LOCATION" : {
        (SAFEZONES findIf {locationPosition _entity inArea _x}) > -1
    };
    case "STRING" : {
        (SAFEZONES findIf {getMarkerPos _entity inArea _x}) > -1 
    };
    default {};
};
