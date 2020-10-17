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

private _comms = [];

[GVAR(outposts),{
    // get random positions in polygon
    private _polygon = ([GVAR(areas),_key] call CBA_fnc_hashGet) getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON];
    private _polygonPositions = [_polygon,10] call EFUNC(main,polygonRandomPos);

    // find suitable position
    _polygonPositions = _polygonPositions select {[_x,0,0,0.275] call EFUNC(main,isPosSafe)};

    // exit if no positions left
    if !(_polygonPositions isEqualTo []) then {
        // create location
        _location = createLocation ["Invisible",ASLtoAGL (selectRandom _polygonPositions),1,1];

        // setvars
        _location setVariable [QGVAR(status),true];
        _location setVariable [QGVAR(type),"comm"];
        _location setVariable [QGVAR(name),call FUNC(getName)];
        _location setVariable [QGVAR(positionASL),AGLtoASL (getPos _location)];
        _location setVariable [QGVAR(composition),[]];
        _location setVariable [QGVAR(radius),0];
        _location setVariable [QGVAR(groups),[]]; // groups assigned to comm array

        // setup hash
        _comms pushBack [_key,_location];
    } else {
        ERROR_1("cannot find suitable comm position for %1",_key);
    };
}] call CBA_fnc_hashEachPair;

// create hash
GVAR(comms) = [_comms,locationNull] call CBA_fnc_hashCreate;

(count ([GVAR(comms)] call CBA_fnc_hashKeys)) isEqualTo (count ([GVAR(outposts)] call CBA_fnc_hashKeys))