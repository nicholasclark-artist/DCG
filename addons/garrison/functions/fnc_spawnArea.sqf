/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn areas, should not be called directly

Arguments:

Return:
nothing
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnArea)

// define scope to break hash loop
scopeName SCOPE;

private ["_positions","_positionsLand","_positionsWater","_mrk"];

[GVAR(areas),{
    _positions = _value getVariable [QGVAR(patrolPositions),[]];

    _positionsLand = _positions select {!(surfaceIsWater _x)};
    _positionsWater = _positions select {surfaceIsWater _x && {(getTerrainHeightASL _x) <= -10}};

    _positionsLand = _positionsLand call BIS_fnc_arrayShuffle;
    _positionsWater = _positionsWater call BIS_fnc_arrayShuffle;

    _positionsLand resize (count _positionsLand min PAT_LIMIT);
    _positionsWater resize (count _positionsWater min PAT_LIMIT_WATER);

    TRACE_2("",count _positionsLand,count _positionsWater);

    {
        _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        _mrk setMarkerType "mil_dot";
        _mrk setMarkerColor "ColorUNKNOWN";
    } forEach _positionsLand;

    {
        _mrk = createMarker [format["%1",_forEachIndex + (random 10000)],_x];
        _mrk setMarkerType "mil_dot";
        _mrk setMarkerColor "ColorBLUE";
    } forEach _positionsWater;
}] call CBA_fnc_hashEachPair;

nil