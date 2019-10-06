/*
Author:
Nicholas Clark (SENSEI)

Description:
set area of operations on server

Arguments:
0: data loaded from server profile <ARRAY>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setArea)
#define AO_SEARCH_RADIUS 3000

if !(isServer) exitWith {false};

params [
    ["_data",[],[[]]]
];

// @todo remove area if contains safezone 

scopeName SCOPE;

private ["_location","_id"];
private _hash = [];
private _polygons = [];
private _locations = [];

if !(_data isEqualTo []) then {

} else {
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

    if (_locations isEqualTo []) then {false breakOut SCOPE};
};

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

    // setup area hash
    _hash pushBack [text _x,_location];

    // setup draw area
    _polygons pushBack _polygon;
} forEach _locations;

// create area hash
GVAR(areas) = [_hash,locationNull] call CBA_fnc_hashCreate;

// get dynamic task 

// get outposts
private _outpost = call FUNC(setOutpost);
TRACE_1("",_outpost);

// get garrison
GVAR(garrisons) = [[],locationNull] call CBA_fnc_hashCreate;
GVAR(comms) = [[],locationNull] call CBA_fnc_hashCreate;

// exit if cant find positions 
if (_outpost isEqualTo 0 /* || {!_garrison} */) exitWith {false/* call FUNC(removeArea) */};

// spawn outposts and garrison
[] call FUNC(spawnOutpost);

// adjust approval 
// @todo lower approval in regions occupied by enemy 

// draw area on map
[
    [_polygons,_id],
    {
        {
            [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",true,findDisplay 12 displayCtrl 51,_this select 1] call EFUNC(main,polygonFill);
        } forEach (_this select 0); 
    }
] remoteExecCall [QUOTE(call), 0, false];

// set tasks 

true