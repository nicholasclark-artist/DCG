/*
Author:
Nicholas Clark (SENSEI)

Description:
set area of operations

Arguments:
0: ao count <NUMBER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

if !(isServer) exitWith {};

params [
    ["_count",1,[0]]
];

private _hash = [];

// get keys from main hash
private _keys = [EGVAR(main,locations)] call CBA_fnc_hashKeys;
_keys = _keys call BIS_fnc_arrayShuffle;

// remove active keys
if !(isNil QGVAR(areas)) then {
    _keys = _keys select {!([GVAR(areas),_x] call CBA_fnc_hashHasKey)};
};

// make sure count is not too high
if (_count > (count _keys)) then {
    _count = _count min (count _keys);

    WARNING("count param is higher than number of available keys");
};

private ["_key","_location","_polygon","_safe","_patrolPositions","_patrolCount","_length","_spacing"];

{
    if (count _hash >= _count) exitWith {};

    _key = _x;

    // get hash location 
    _location = [EGVAR(main,locations),_key] call CBA_fnc_hashGet;
    _polygon = _location getVariable [QEGVAR(main,polygon),[]];

    // check if ao is suitable
    // @todo improve safezone & polygon intersection check, currently only checking if location is in safezone not entire polygon
    _safe = _hash findIf {COMPARE_STR(_key,_x select 0)} < 0 && {!([_location] call EFUNC(main,inSafezones))};
    
    if (_safe) then {
        // get patrol spawn positions 
        _length = [_polygon] call EFUNC(main,polygonLength);
        _spacing = _length / round (_length / (PAT_SPACING min (_length * 0.5)));

        _patrolPositions = [[_polygon,1] call EFUNC(main,polygonCenter),_spacing,_length] call EFUNC(main,findPosGrid);
        _patrolPositions = _patrolPositions select {[_x select 0,_x select 1,0] inPolygon _polygon};

        // _patrolPositions = _patrolPositions select {!(surfaceIsWater _x)};
        // _patrolPositions = _patrolPositions call BIS_fnc_arrayShuffle;
        // _patrolPositions resize (count _patrolPositions min (count _patrolPositions / (([_polygon] call EFUNC(main,polygonArea)) * 0.5)));

        TRACE_3("",_key,_spacing,count _patrolPositions);

        // {
        //     _mrk = createMarker [format["%1",diag_frameNo + (random 10000)],_x];
        //     _mrk setMarkerType "mil_dot";
        //     _mrk setMarkerColor "ColorUNKNOWN";
        // } forEach _patrolPositions;

        // set area variables
        _location setVariable [QGVAR(status),1];
        _location setVariable [QGVAR(name),call FUNC(getName)];
        _location setVariable [QGVAR(task),""];
        _location setVariable [QGVAR(groups),[]];
        _location setVariable [QGVAR(patrolPositions),_patrolPositions];

        // setup area hash
        _hash pushBack [_key,_location];
    };
} forEach _keys;

if (count _hash isEqualTo 0) exitWith {
    WARNING("cannot find areas");
    false
};

// add locations to hash
if (isNil QGVAR(areas)) then {
    GVAR(areas) = [_hash,locationNull] call CBA_fnc_hashCreate;
} else {
    {
        [GVAR(areas),_x select 0,_x select 1] call CBA_fnc_hashSet;
    } forEach _hash;
};

count _hash isEqualTo _count