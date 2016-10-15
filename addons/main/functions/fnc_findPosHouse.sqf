/*
Author:
Nicholas Clark (SENSEI)

Description:
finds an interior house position

Arguments:
0: center position <ARRAY>
1: search distance <NUMBER>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"
#define BAD_HOUSES ["Land_HouseV_1L2"]

private _center = param [0,[0,0,0]];
private _range = param [1,100,[0]];
private _return = [];

private _houseArray = _center nearObjects ["House",_range];
_houseArray = _houseArray select {!((_x buildingPos -1) isEqualTo []) && {!(typeOf _x in BAD_HOUSES)}};

if !(_houseArray isEqualTo []) then {
	private _house = selectRandom _houseArray;
	private _housePosArray = _house buildingPos -1;

	{
		if (_x call FUNC(inBuilding)) exitWith {
			_return = [_house,ATLtoASL _x];
		};
		false
	} count _housePosArray;
};

_return