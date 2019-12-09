/*
Author:
Nicholas Clark (SENSEI)

Description:
set garrison locations

Arguments:

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setGarrison)

// define scope to break hash loop
scopeName SCOPE;

// get random AO location
private _location = [GVAR(areas), selectRandom ([GVAR(areas)] call CBA_fnc_hashKeys)] call CBA_fnc_hashGet;

// set as garrison location
// no need for separate garrison hash as garrison location is same as AO location
_location setVariable [QGVAR(activeGarrison),1];
_location setVariable [QGVAR(taskGarrison),""];
_location setVariable [QGVAR(nameGarrison),call EFUNC(main,getAlias)];

// update score
[QGVAR(updateScore),[_location,GAR_SCORE]] call CBA_fnc_localEvent;

nil