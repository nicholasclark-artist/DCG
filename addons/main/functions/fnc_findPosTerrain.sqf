/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a positionASL of a certain terrain type. If the terrain type is "house",the function returns an array including the house object and position

Arguments:
0: center position <ARRAY>
1: search radius <NUMBER>
2: terrain type <STRING>
3: minimum expression value <NUMBER>
4: object radius <NUMBER>
5: gradient radius <NUMBER>
6: find rural position <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST 400
#define DIST_HOUSE 100
#define GRAD1 0.172
#define GRAD2 0.274

params [
    ["_center",[],[[]]],
    ["_radius",100,[0]],
    ["_terrain","",[""]],
    ["_minValue",0,[0]],
    ["_rSafe",-1,[0]],
    ["_rGrad",-1,[0]],
    ["_rural",false,[false]]
];

private _ret = [];
private _expression = "";

call {
    if (COMPARE_STR(_terrain,"meadow")) exitWith {
        _expression = EX_MEADOW;
    };
    if (COMPARE_STR(_terrain,"forest")) exitWith {
        _expression = EX_FOREST;
    };
    if (COMPARE_STR(_terrain,"house")) exitWith {
        _expression = EX_HOUSES;
    };
    if (COMPARE_STR(_terrain,"peak")) exitWith {
        _expression = EX_HILLS;
    };
    if (COMPARE_STR(_terrain,"hill")) exitWith {
        _expression = EX_HILLS_LOWER;
    };
    if (COMPARE_STR(_terrain,"coast")) exitWith {
        _expression = EX_COAST;
    };
    if (COMPARE_STR(_terrain,"sea")) exitWith {
        _expression = EX_SEA;
    };
    if (COMPARE_STR(_terrain,"deep sea")) exitWith {
        _expression = EX_SEA_DEEP;
    };
};

if (COMPARE_STR(_expression,"")) exitWith {
    WARNING("cannot find position,expression is empty");
};

// search count and precision is limited
private _places = selectBestPlaces [_center,_radius,_expression,100,10];

// use toFixed to account for extremely small scores that do not satisfy passed expression
_places = _places select {(parseNumber ((_x select 1) toFixed 2)) > _minValue};

if (_rural) then {
    _places = _places select {(nearestLocations [_x select 0,["NameVillage","NameCity","NameCityCapital"],DIST]) isEqualTo []};
};

// places are sorted by score in descending order,shuffle for more variation 
_places = _places call BIS_fnc_arrayShuffle;

{
    if !(_terrain isEqualTo "house") then {
        // check safe distance from objects,water positions not allowed
        if (_rSafe > 0 && {!([_x select 0,_rSafe,0] call FUNC(isPosSafe))}) exitWith {};

        // check gradients,check at two distances
        if (_rGrad > 0 && {(_x select 0) isFlatEmpty [-1,-1,GRAD1,_rGrad * 0.25,-1] isEqualTo []} && {(_x select 0) isFlatEmpty [-1,-1,GRAD2,_rGrad,-1] isEqualTo []}) exitWith {};

        _ret =+ _x select 0;
        _ret set [2,ASLZ(_ret)];
    } else {
        _ret = [_x select 0,DIST_HOUSE] call FUNC(findPosBuilding);
    };

    if !(_ret isEqualTo []) exitWith {};
} forEach _places;

_ret