/*
Author:
Nicholas Clark (SENSEI)

Description:
set outpost locations

Arguments:
0: outpost count <NUMBER>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setOutpost)

if !(isServer) exitWith {};

params [
    ["_count",1,[0]]
];

// define scope to break hash loop
scopeName SCOPE;

private ["_polygon","_outposts","_pos","_polygonPositions","_terrain","_location"];

_outposts = [];

[GVAR(areas),{
    // exit when outpost count reached
    if (count _outposts >= _count) then {
        breakTo SCOPE;
    };

    _polygon = _value getVariable [QEGVAR(main,polygon),[]];
    _pos = [];
    _terrain = "";

    // get random positions in polygon
    // raise iterations if outpost count is consistently low
    _polygonPositions = [_polygon,20] call EFUNC(main,polygonRandomPos);
    
    // find position based on terrain type
    {
        private _terrainKVP = selectRandom [["meadow",50],["peak",20],["forest",20]];
        _pos = [_x,500,_terrainKVP select 0,0,-1,_terrainKVP select 1,true] call EFUNC(main,findPosTerrain);

        // exit when position found
        if (!(_pos isEqualTo []) && {_pos inPolygon _polygon}) exitWith {
            _terrain = _terrainKVP select 0;
        }; 
    } forEach _polygonPositions;

    if !(_pos isEqualTo []) then { 
        // @todo fix water positions 
        TRACE_3("",_key,_terrain,_pos);

        // create outpost location
        _location = createLocation ["Invisible",ASLtoAGL _pos,1,1];
        
        // setvars
        _location setVariable [QGVAR(status),1];
        _location setVariable [QGVAR(type),"outpost"];
        _location setVariable [QGVAR(name),call FUNC(getName)]; 
        _location setVariable [QGVAR(task),""];
        _location setVariable [QGVAR(composition),[]];
        _location setVariable [QGVAR(nodes),[]];
        _location setVariable [QGVAR(radius),0]; // will be adjusted based on composition size
        _location setVariable [QGVAR(terrain),_terrain];
        _location setVariable [QGVAR(positionASL),_pos];
        _location setVariable [QGVAR(groups),[]]; // groups assigned to outpost

        // setup hash
        _outposts pushBack [_key,_location];

        // update score
        [QGVAR(updateScore),[_value,OP_SCORE]] call CBA_fnc_localEvent;
    } else {
        WARNING_1("cannot find suitable position for %1",_key);
    }
}] call CBA_fnc_hashEachPair;

// create outpost hash
GVAR(outposts) = [_outposts,locationNull] call CBA_fnc_hashCreate;

count _outposts isEqualTo _count