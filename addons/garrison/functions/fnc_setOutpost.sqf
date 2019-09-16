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
#define SCOPE QGVAR(setOutpost)

// define scope to break hash loop
scopeName SCOPE;

private _outposts = [];

[GVAR(areas),{
    private _pos = [];
    private _polygonPositions = [];
    private _type = "";
    private _aliasAO = _value getVariable [QGVAR(name),""];

    // get random positions in polygon
    for "_i" from 0 to 4 do {
        _pos = [_value getVariable [QEGVAR(main,polygon),[]]] call EFUNC(main,polygonRandomPos);
        _polygonPositions pushBack _pos;
    };
    
    // find position based on terrain type
    { 
        private _terrain = selectRandom [["meadow",50], ["hill",20], ["forest",20]];
        _pos = [_x,500,_terrain select 0,1,0,_terrain select 1,true] call EFUNC(main,findPosTerrain);

        // exit when position found
        if !(_pos isEqualTo []) exitWith {
            _type = _terrain select 0;
            TRACE_2("",_key,_type);
        }; 
    } forEach _polygonPositions;

    if (!(_pos isEqualTo []) && {_pos inPolygon (_value getVariable [QEGVAR(main,polygon),[]])}) then {
        // create outpost location
        _location = createLocation ["Invisible",ASLtoAGL _pos,1,1];
        
        // select outpost alias
        private _alias = call EFUNC(main,getAlias);

        // try getting a new alias if same as AO
        if (COMPARE_STR(_alias,_aliasAO)) then { 
            _alias = call EFUNC(main,getAlias);
            WARNING("outpost and area aliases are the same. selecting new alias")
        }; 

        // setvars
        _location setVariable [QGVAR(active),1];
        _location setVariable [QGVAR(name),_alias]; 
        _location setVariable [QGVAR(task),""];
        _location setVariable [QGVAR(composition),[]];
        _location setVariable [QGVAR(terrain),_type];
        _location setVariable [QGVAR(positionASL),_pos];
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
GVAR(outposts) = [_outposts,locationNull] call CBA_fnc_hashCreate;

count ([GVAR(outposts)] call CBA_fnc_hashKeys)
