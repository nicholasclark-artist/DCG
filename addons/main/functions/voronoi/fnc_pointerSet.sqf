/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: 
*/

#include "script_component.hpp"

params [
    ["_container", objNull, [objNull]],
    "_adress",
    "_value"
];

if(_adress == PTR_NULL) exitWith {
    ["Invalid parameter ""pointer"" - A pointer name must be provided. Parameters received: %1", _this] call BIS_fnc_error;
};

if(isNil "_value") exitWith { 
    _container setVariable [_adress, nil]; 
};
_container setVariable [_adress, _value];