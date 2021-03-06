/*
Author:
Nicholas Clark (SENSEI)

Description:
set garrison locations

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"

private _garrisons = [];

// get random AO location
private _key = selectRandom ([GVAR(areas)] call CBA_fnc_hashKeys);
private _ao = [GVAR(areas),_key] call CBA_fnc_hashGet;

// create location
private _location = createLocation ["Invisible",getPos _ao,1,1];

// set vars
_location setVariable [QGVAR(status),true];
_location setVariable [QGVAR(type),"garrison"];
_location setVariable [QGVAR(name),call FUNC(getName)];
_location setVariable [QGVAR(task),""];
_location setVariable [QGVAR(positionASL),AGLtoASL (getPos _location)];
_location setVariable [QGVAR(radius),_ao getVariable [QEGVAR(main,radius),0]];
_location setVariable [QGVAR(groups),[]]; // groups assigned to garrison

_location setVariable [QGVAR(prefabs),[]];

// setup hash
_garrisons pushBack [_key,_location];

// create hash
GVAR(garrisons) = [_garrisons,locationNull] call CBA_fnc_hashCreate;

(count ([GVAR(garrisons)] call CBA_fnc_hashKeys)) > 0
