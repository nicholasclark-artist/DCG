/*
    Author: mrCurry (https://forums.bohemia.net/profile/759255-mrcurry/)
    Date: 2018-10-12
    Please do not redistribute this work without acknowledgement of the original author. 
    You are otherwise free to use this code as you wish.

    Description: Returns a container (Object) prepared for pointer management.
*/

#include "script_component.hpp"
params [
    ["_container", objNull, [objNull]]
];

if(isNull _container) then {
    _container = createGroup sideLogic createUnit ["Logic", [0,0,0], [], 0, "NONE"];
};

if(isNil {_container getVariable "POINTER_NUM"}) then {
    _container setVariable ["POINTER_NUM", 0];
};

_container