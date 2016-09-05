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

private _center = param [0,[0,0,0]];
private _range = param [1,100,[0]];
private _return = [];

private _houseArray = _center nearObjects ["House",_range];
_houseArray = _houseArray select {!((_x buildingPos -1) isEqualTo [])};

if !(_houseArray isEqualTo []) then {
	private _house = selectRandom _houseArray;
	private _housePosArray = _house buildingPos -1;

	{
		if (_x call FUNC(inBuilding)) exitWith {
			private _pos = _x;
			_pos set [2,getTerrainHeightASL _pos];
			_return = [_house,_pos];
		};
	} foreach _housePosArray;
};

_return