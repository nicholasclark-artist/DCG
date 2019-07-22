/*
Author:
Nicholas Clark (SENSEI)

Description:
set outpost area on server

Arguments:
0: data loaded from server profile <ARRAY>

Return:
bool
__________________________________________________________________*/
#include "script_component.hpp"
#define AO_SEARCH_RADIUS 3000
#define AO_COUNT 3

if !(isServer) exitWith {false};

params [
    ["_data",[],[[]]]
];

private ["_locations","_polygons","_id"];

if !(_data isEqualTo []) then {
    _locations = _data select 0;
    _polygons = _data select 1;
    _id = _data select 2;
} else {
    _id = QGVAR(polygonDraw);

    // get primary location
    private _primary = [EGVAR(main,locations), selectRandom ([EGVAR(main,locations)] call CBA_fnc_hashKeys)] call CBA_fnc_hashGet;

    if (_primary isEqualTo []) exitWith {false};

    // get list of locations in area, includes primary location
    _locations = nearestLocations [_primary select 0, ["namecitycapital","namecity","namevillage"],AO_SEARCH_RADIUS];

    // make sure locations have data
    private _rem = [];
    _locations = _locations apply {text _x};

    {
        if (!([EGVAR(main,locations),_x] call CBA_fnc_hashHasKey) || {!([EGVAR(main,locationPolygons),_x] call CBA_fnc_hashHasKey)}) then {
            _rem pushBack _x;
        };
    } forEach _locations;

    _locations = _locations - _rem;
    _locations resize (count _locations min AO_COUNT);

    if (_locations isEqualTo []) exitWith {false};

    // @todo current method not always selecting nearest locations 
    TRACE_1("",_locations);

    // get ao polygon from selected locations 
    _polygons = [];

    [EGVAR(main,locationPolygons), {
        if (_key in _locations) then {
            private _polygon = [_value] call EFUNC(main,polygonSort);
            _polygons pushBack _polygon;
        };
    }] call CBA_fnc_hashEachPair;
};

// draw ao on map
[
    [_polygons,_id],
    {
        {
            [_x,[EGVAR(main,enemySide),false] call BIS_fnc_sideColor,"\A3\ui_f\data\map\markerbrushes\bdiagonal_ca.paa",findDisplay 12 displayCtrl 51,_this select 1] call EFUNC(main,polygonFill);
        } forEach (_this select 0); 
    }
] remoteExecCall [QUOTE(call), 0, false];

// set global reference
missionNamespace setVariable [QGVAR(area),[_locations,_polygons,_id]];

true