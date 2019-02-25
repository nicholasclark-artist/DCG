/*
Author:
Nicholas Clark (SENSEI)

Description:
finds a positionASL of a certain terrain type. If the terrain type is "house", the function returns an array including the house object and position

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>
2: terrain type <STRING>
3: safe position distance check <NUMBER>
4: find rural position <BOOL>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define DIST 500
#define DIST_HOUSE 100
#define GRAD 0.275

params [
    ["_anchor",[],[[]]],
    ["_range",100,[0]],
    ["_terrain","",[""]],
    ["_check",0,[0]],
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
    WARNING("Cannot find position, expression is empty");
};

private _places = selectBestPlaces [_anchor,_range,_expression,100,20];

_places = if !(_rural) then {
    _places select {(_x select 1) > 0 && {!([_x select 0] call FUNC(inSafezones))}};
} else {
    _places select {(_x select 1) > 0 && {((nearestLocations [(_x select 0), ["NameVillage","NameCity","NameCityCapital"], DIST]) isEqualTo [])} && {!([_x select 0] call FUNC(inSafezones))}};
};

{
    if !(_terrain isEqualTo "house") then {
        if (_check > 0 && {!([_x select 0,_check,0,GRAD] call FUNC(isPosSafe))}) exitWith {};

        _ret =+ _x select 0;
        _ret set [2,ASLZ(_ret)];
    } else {
        _ret = [_x select 0,DIST_HOUSE] call FUNC(findPosHouse);
    };

    if !(_ret isEqualTo []) exitWith {};
} forEach _places;

_ret
