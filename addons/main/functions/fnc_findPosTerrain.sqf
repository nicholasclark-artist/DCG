/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a positionASL of a certain terrain type. If the terrain type is "house", the function returns an array including the house object and position

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>
2: terrain type <STRING>
3: number of positions to find <NUMBER>
4: object radius <NUMBER>
4: gradient radius <NUMBER>
5: find rural position <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST 400
#define DIST_HOUSE 100
#define GRAD1 0.173
#define GRAD2 0.275

params [
    ["_anchor",[],[[]]],
    ["_range",100,[0]],
    ["_terrain","",[""]],
    ["_count",1,[0]],
    ["_rSafe",0,[0]],
    ["_rGrad",0,[0]],
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
    if (COMPARE_STR(_terrain,"hill")) exitWith {
        _expression = EX_HILL;
    };
};

if (COMPARE_STR(_terrain,"") || {COMPARE_STR(_expression,"")}) exitWith {
    WARNING("cannot find position, expression is empty");
};

private _places = selectBestPlaces [_anchor,_range,_expression,100,_count];
_places = _places select {(_x select 1) > 0};

if (_rural) then {
    _places = _places select {(nearestLocations [_x select 0, ["NameVillage","NameCity","NameCityCapital"], DIST]) isEqualTo []};
};

{
    if !(_terrain isEqualTo "house") then {
        // check safe distance from objects, water positions not allowed
        if (_rSafe > 0 && {!([_x select 0,_rSafe,0] call FUNC(isPosSafe))}) exitWith {};

        // check gradients, check at two distances
        if (((_x select 0) isFlatEmpty [-1, -1, GRAD1, _rGrad * 0.25, -1] isEqualTo []) && {(_x select 0) isFlatEmpty [-1, -1, GRAD2, _rGrad, -1] isEqualTo []}) exitWith {};

        _ret =+ _x select 0;
        _ret set [2,ASLZ(_ret)];
    } else {
        _ret = [_x select 0,DIST_HOUSE] call FUNC(findPosHouse);
    };

    if !(_ret isEqualTo []) exitWith {};
} forEach _places;

_ret