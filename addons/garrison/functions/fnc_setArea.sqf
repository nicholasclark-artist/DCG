/*
Author:
Nicholas Clark (SENSEI)

Description:
set area of operations

Arguments:

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define AO_SEARCH_RADIUS 3000

// @todo remove area if contains safezone 

private ["_location","_id"];
private _hash = [];
private _polygons = [];
private _locations = [];

_id = QGVAR(polygonDraw);

// get primary location
private _primary = [EGVAR(main,locations), selectRandom ([EGVAR(main,locations)] call CBA_fnc_hashKeys)] call CBA_fnc_hashGet;

// get list of locations in area, includes primary location
_locations = nearestLocations [_primary getVariable [QEGVAR(main,positionASL),DEFAULT_SPAWNPOS], ["namecitycapital","namecity","namevillage"],AO_SEARCH_RADIUS];

// make sure locations have data
private _rem = [];

{
    if !([EGVAR(main,locations),text _x] call CBA_fnc_hashHasKey) then {
        _rem pushBack _x;
    };
} forEach _locations;

// remove locations that are not in hashes
_locations = _locations - _rem;
_locations resize (count _locations min AO_COUNT);

if (_locations isEqualTo []) exitWith {false};

// shuffle to randomize outpost spawns
[_locations] call EFUNC(main,shuffle);

{
    // get hash location 
    _location = [EGVAR(main,locations), text _x] call CBA_fnc_hashGet;

    // get location polygon 
    private _polygon = _location getVariable [QEGVAR(main,polygon),DEFAULT_POLYGON];

    // set area variables
    _location setVariable [QGVAR(polygonDraw),_id];
    _location setVariable [QGVAR(name),call EFUNC(main,getAlias)];
    _location setVariable [QGVAR(task),""];

    // setup area hash
    _hash pushBack [text _x,_location];

    // setup draw area
    _polygons pushBack _polygon;
} forEach _locations;

// create area hash
GVAR(areas) = [_hash,locationNull] call CBA_fnc_hashCreate;

(count ([GVAR(areas)] call CBA_fnc_hashKeys)) > 0