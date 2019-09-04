/*
Author:
Nicholas Clark (SENSEI)

Description:
set outpost locations

Arguments:

Return:
number
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE _fnc_scriptName

// define scope to break hash loop
scopeName SCOPE;

private _outposts = [];

[GVAR(areas),{
    private _pos = [];
    private _polygonPositions = [];
    private _type = "";

    // get random positions in polygon
    for "_i" from 0 to 4 do {
        _pos = [_value getVariable [QGVAR(polygon),[]]] call EFUNC(main,polygonRandomPos);
        _polygonPositions pushBack _pos;
    };
    
    // find position based on terrain type
    { 
        _type = selectRandom ["meadow", "hill", "forest"];
        _pos = [_x,500,_type,1,0,true] call EFUNC(main,findPosTerrain);

        // exit when position found
        if !(_pos isEqualTo []) exitWith {TRACE_2("",_key,_type)}; 
    } forEach _polygonPositions;

    if (!(_pos isEqualTo []) && {_pos inPolygon (_value getVariable [QGVAR(polygon),[]])}) then {
        // create outpost location
        _location = createLocation ["Invisible",ASLtoAGL _pos,1,1];
        
        // select outpost alias
        private _alias = call EFUNC(main,getAlias);

        // try getting a new alias if same as AO
        if (COMPARE_STR(_alias, text _value)) then {
            _alias = call EFUNC(main,getAlias);
            WARNING_1("outpost and area alias are the same. selecting new alias")
        }; 

        _location setText _alias;

        // setvars
        _location setVariable [QGVAR(terrain),_type];
        _location setVariable [QGVAR(radius),100]; // will be adjusted based on composition size
        _location setVariable [QGVAR(groups),[]]; // groups assigned to outpost
        _location setVariable [QGVAR(unitCountCurrent),0]; // actual unit count
        _location setVariable [QGVAR(officer),objNull];
        _location setVariable [QGVAR(onKilled),{ // update unit count on killed event
            _this setVariable [QGVAR(unitCountCurrent),(_this getVariable [QGVAR(unitCountCurrent),-1]) - 1];
        }];

        // setup hash
        _outposts pushBack [_key,_location];
    };
}] call CBA_fnc_hashEachPair;

// create outpost hash
GVAR(outposts) = [_outposts,[]] call CBA_fnc_hashCreate;

count ([GVAR(outposts)] call CBA_fnc_hashKeys)
