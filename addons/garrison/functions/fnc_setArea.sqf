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
#define SCOPE _fnc_scriptName
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

    if (_primary isEqualTo []) then {false breakOut SCOPE};

    // get list of locations in area, includes primary location
    _locations = nearestLocations [_primary select 0, ["namecitycapital","namecity","namevillage"],AO_SEARCH_RADIUS];

    // make sure locations have data
    private _rem = [];

    {
        if (!([EGVAR(main,locations),text _x] call CBA_fnc_hashHasKey) || {!([EGVAR(main,locationPolygons),text _x] call CBA_fnc_hashHasKey)}) then {
            _rem pushBack _x;
        };
    } forEach _locations;

    // remove locations that are not in hashes
    _locations = _locations - _rem;
    _locations resize (count _locations min AO_COUNT);

    if (_locations isEqualTo []) then {false breakOut SCOPE};
};

{
    // get location polygon 
    private _polygon = [EGVAR(main,locationPolygons), text _x] call CBA_fnc_hashGet;

    // set position2D
    private _pos = getPos _x;
    _pos resize 2;

    // create area location
    _location = createLocation ["Invisible",_pos,1,1];
    _location setText (call EFUNC(main,getAlias)); 

    // set variables
    _location setVariable [QGVAR(id),_id];
    _location setVariable [QGVAR(polygon),_polygon]; 
    _location setVariable [QGVAR(nearestLocation),_x];

    // setup hash
    _hash pushBack [text _x,_location];

    // setup draw area
    _polygons pushBack _polygon;
} forEach _locations;

// create area hash
GVAR(areas) = [_hash,[]] call CBA_fnc_hashCreate;

// get dynamic task 

// get outposts
private _outpost = call FUNC(setOutpost);

// get garrison

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

true