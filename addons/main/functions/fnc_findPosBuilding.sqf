/*
Author:
Nicholas Clark (SENSEI)

Description:
finds an interior building position. Returns an array with the building and the selected building positionASL

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define BLACKLIST ["Land_HouseV_1L2"]

params [
    ["_center",[0,0,0],[[]]],
    ["_range",100,[0]]
];

private _return = [];

private _buildings = _center nearObjects ["House",_range];
_buildings = _buildings select {!((_x buildingPos -1) isEqualTo []) && {!(typeOf _x in BLACKLIST)}};

if !(_buildings isEqualTo []) then {
    private _building = selectRandom _buildings;
    private _buildingPositions = _building buildingPos -1;

    {
        if ([_x] call FUNC(inBuilding)) exitWith {
            _return = [_building,ATLtoASL _x];
        };
    } forEach _buildingPositions;
};

_return