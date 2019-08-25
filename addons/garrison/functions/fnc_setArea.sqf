/*
Author:
Nicholas Clark (SENSEI)

Description:
set ao on server

Arguments:
0: data loaded from server profile <ARRAY>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define AO_SEARCH_RADIUS 3000

if !(isServer) exitWith {false};

params [
    ["_data",[],[[]]]
];

// @todo remove area if contains safezone 

private ["_location","_id"];
private _hash = [];
private _polygons = [];
private _locations = [];

if !(_data isEqualTo []) then {
    // load saved data, [map location, sorted polygon, id]
    // _id = _data select 0 select 2;

    // {
    //     _locations pushBack (_x select 0);
    //     _polygons pushBack (_x select 1);
    // } forEach _data;
} else {
    _id = QGVAR(polygonDraw);

    // get primary location
    private _primary = [EGVAR(main,locations), selectRandom ([EGVAR(main,locations)] call CBA_fnc_hashKeys)] call CBA_fnc_hashGet;

    if (_primary isEqualTo []) exitWith {false};

    // get list of locations in area, includes primary location
    _locations = nearestLocations [_primary select 0, ["namecitycapital","namecity","namevillage"],AO_SEARCH_RADIUS];

    // make sure locations have data
    private _rem = [];

    {
        if (!([EGVAR(main,locations),text _x] call CBA_fnc_hashHasKey) || {!([EGVAR(main,locationPolygons),text _x] call CBA_fnc_hashHasKey)}) then {
            _rem pushBack _x;
        };
    } forEach _locations;

    _locations = _locations - _rem;
    _locations resize (count _locations min AO_COUNT);

    if (_locations isEqualTo []) exitWith {false};

    // get ao polygon from selected locations
    {
        private _polygon = [[EGVAR(main,locationPolygons), text _x] call CBA_fnc_hashGet] call EFUNC(main,polygonSort);
        _polygons pushBack _polygon;
    } forEach _locations;
};

{
    // create area location
    _location = createLocation ["Invisible",getPos _x,1,1];
    _location setText (call EFUNC(main,getAlias));

    // get radius of polygon
    private _polygonRadii =+ _polygons select _forEachIndex;
    _polygonRadii = _polygonRadii apply {(getPos _location) distance2D _x};

    // set variables
    _location setVariable [QGVAR(id),_id];
    _location setVariable [QGVAR(polygon),_polygons select _forEachIndex];
    _location setVariable [QGVAR(polygonRadius),selectMax _polygonRadii];
    _location setVariable [QGVAR(nearestLocation),_x];
    // _location setVariable [QGVAR(alias),_alias];
    // _location setVariable [QGVAR(rural),0];
    // _location setVariable [QGVAR(unitCount),GAR_UNITCOUNT];
    // _location setVariable [QGVAR(unitCountCurrent),GAR_UNITCOUNT];
    // _location setVariable [QGVAR(commsArray),1];
    // _location setVariable [QGVAR(reinforce),0];
    // _location setVariable [QGVAR(officer),objNull];

    // setup hash
    _hash pushBack [text _x,_location];
} forEach _locations;

// create ao hash
GVAR(areas) = [_hash,[]] call CBA_fnc_hashCreate;

// get dynamic task 

// get outposts
private _outpost = call FUNC(setOutpost);

// get garrison

// exit if cant find all positions 
if (!_outpost /* || {!_garrison} */) exitWith {false};

// spawn outposts and garrison
[] call FUNC(spawnOutpost);

// draw ao on map
[
    [_polygons,_id],
    {
        {
            [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",findDisplay 12 displayCtrl 51,_this select 1] call EFUNC(main,polygonFill);
        } forEach (_this select 0); 
    }
] remoteExecCall [QUOTE(call), 0, false];

true