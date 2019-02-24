/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author.
    You are otherwise free to use this code as you wish.

    Description: Stores _data in _container at a new adress. The new adress is returned.
*/

#include "script_component.hpp"

params [
    ["_container", objNull, [objNull]],
    "_data"
];

private _num = _container getVariable "POINTER_NUM";
if(isNil "_num" || { !(_num isEqualType 0) }) exitWith {
    ["Invalid parameter ""container"" - Container not properly initilized, only pass containers created using FUNC(pointerNewContainer). Parameters received: %1", _this] call BIS_fnc_error;
};
_container setVariable ["POINTER_NUM", _num + 1];

private _adress = format ["%1%2", POINTER_PREFIX, _num];

if(isNil "_data") exitWith {
    _container setVariable [_adress, nil];
    _adress;
};

_container setVariable [_adress, _data];
_adress;