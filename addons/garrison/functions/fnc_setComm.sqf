/*
Author:
Nicholas Clark (SENSEI)

Description:
set comm array locations

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setComm)

// define scope to break hash loop
scopeName SCOPE;

private ["_polygon","_polygonPositions"];

private _comms = [];

[GVAR(garrisons),{
    // get random positions in polygon
    _polygon = ([GVAR(areas),key] call CBA_fnc_hashGet) getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON];
    _polygonPositions = [_polygon,10] call EFUNC(main,polygonRandomPos);

    // find suitable position
    _polygonPositions = _polygonPositions select {[_x,0,0,0.275] call EFUNC(main,isPosSafe)};

    // exit if no positions left
    if (_polygonPositions isEqualTo []) then {
        breakTo SCOPE;
    };
    
    // create location 
    _location = createLocation ["Invisible",ASLtoAGL (selectRandom _polygonPositions),1,1];

    // set vars
    _location setVariable [QGVAR(status),1];
    _location setVariable [QGVAR(type),"comm"];
    _location setVariable [QGVAR(name),call FUNC(getName)];
    _location setVariable [QGVAR(task),""];
    _location setVariable [QGVAR(positionASL),AGLtoASL (getPos _location)];
    _location setVariable [QGVAR(radius),0];
    _location setVariable [QGVAR(groups),[]]; // groups assigned to comm array

    // setup hash
    _comms pushBack [_key,_location];

    // update score
    [QGVAR(updateScore),[_location,COMM_SCORE]] call CBA_fnc_localEvent;
}] call CBA_fnc_hashEachPair;

// create hash
GVAR(comms) = [_comms,locationNull] call CBA_fnc_hashCreate;

(count ([GVAR(comms)] call CBA_fnc_hashKeys)) > 0