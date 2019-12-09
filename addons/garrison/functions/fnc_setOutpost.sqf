/*
Author:
Nicholas Clark (SENSEI)

Description:
set outpost locations

Arguments:

Return:
nil
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(setOutpost)

// define scope to break hash loop
scopeName SCOPE;

private ["_outposts","_pos","_polygonPositions","_type","_aliasGarrison","_location"];

_outposts = [];

[GVAR(areas),{
    // exit when outpost count reached
    if (count _outposts isEqualTo OP_COUNT) then {
        breakTo SCOPE;
    };

    _pos = [];
    _polygonPositions = [];
    _type = "";
    _aliasGarrison = _value getVariable [QGVAR(nameGarrison),""];

    // get random positions in polygon
    for "_i" from 0 to 4 do {
        _polygonPositions pushBack ([_value getVariable [QEGVAR(main,polygon),[]]] call EFUNC(main,polygonRandomPos));
    };
    
    // find position based on terrain type
    { 
        private _terrain = selectRandom [["meadow",50], ["peak",20], ["forest",20]];
        _pos = [_x,500,_terrain select 0,0,0,_terrain select 1,true] call EFUNC(main,findPosTerrain);

        // exit when position found
        if !(_pos isEqualTo []) exitWith {
            _type = _terrain select 0;
        }; 
    } forEach _polygonPositions;

    if (!(_pos isEqualTo []) && {_pos inPolygon (_value getVariable [QEGVAR(main,polygon),[]])}) then { 
        // create outpost location
        _location = createLocation ["Invisible",ASLtoAGL _pos,1,1];
        
        // select outpost alias
        private _alias = call EFUNC(main,getAlias);

        // try getting a new alias if same as AO
        if (COMPARE_STR(_alias,_aliasGarrison)) then { 
            _alias = call EFUNC(main,getAlias);
            WARNING("outpost and garrison aliases are the same. selecting new alias")
        }; 

        // @todo fix water positions 
        TRACE_3("",_key,_type,_pos);
        
        // setvars
        _location setVariable [QGVAR(active),1];
        _location setVariable [QGVAR(name),_alias]; 
        _location setVariable [QGVAR(task),""];
        _location setVariable [QGVAR(composition),[]];
        _location setVariable [QGVAR(terrain),_type];
        _location setVariable [QGVAR(positionASL),_pos];
        _location setVariable [QGVAR(radius),0]; // will be adjusted based on composition size
        _location setVariable [QGVAR(groups),[]]; // groups assigned to outpost
        _location setVariable [QGVAR(unitCountCurrent),0]; // actual unit count
        _location setVariable [QGVAR(officer),objNull];
        _location setVariable [QGVAR(onKilled),{ // update unit count on killed event
            _this setVariable [QGVAR(unitCountCurrent),(_this getVariable [QGVAR(unitCountCurrent),-1]) - 1];
        }];

        // setup hash
        _outposts pushBack [_key,_location];

        // update score
        [QGVAR(updateScore),[_value,OP_SCORE]] call CBA_fnc_localEvent;
    };
}] call CBA_fnc_hashEachPair;

// create outpost hash
GVAR(outposts) = [_outposts,locationNull] call CBA_fnc_hashCreate;

nil