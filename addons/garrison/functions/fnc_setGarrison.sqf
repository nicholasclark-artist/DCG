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
#define SCOPE QGVAR(setGarrison)

// define scope to break hash loop
scopeName SCOPE;

private _garrisons = [];

// get random AO location
private _key = selectRandom ([GVAR(areas)] call CBA_fnc_hashKeys);
private _ao = [GVAR(areas),_key] call CBA_fnc_hashGet;

// create location 
private _location = createLocation ["Invisible",getPos _ao,1,1];

// set vars
_location setVariable [QGVAR(active),1];
_location setVariable [QGVAR(name),call FUNC(getName)];
_location setVariable [QGVAR(task),""];
_location setVariable [QGVAR(positionASL),AGLtoASL (getPos _location)];
_location setVariable [QGVAR(radius),_ao getVariable [QEGVAR(main,radius),0]];
_location setVariable [QGVAR(groups),[]]; // groups assigned to garrison
_location setVariable [QGVAR(unitCountCurrent),0]; // actual unit count
_location setVariable [QGVAR(onKilled),{ // update unit count on killed event
    _this setVariable [QGVAR(unitCountCurrent),(_this getVariable [QGVAR(unitCountCurrent),-1]) - 1];
}];

// setup hash
_garrisons pushBack [_key,_location];

// update score
[QGVAR(updateScore),[_location,GAR_SCORE]] call CBA_fnc_localEvent;

// create hash
GVAR(garrisons) = [_garrisons,locationNull] call CBA_fnc_hashCreate;

(count ([GVAR(comms)] call CBA_fnc_hashKeys)) > 0
