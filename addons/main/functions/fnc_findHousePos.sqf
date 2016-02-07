/*
Author:
Nicholas Clark (SENSEI)

Description:
finds an interior house position

Arguments:

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

private ["_center","_range","_return","_houseArray","_house","_housePosArray"];

_center = param [0,[0,0,0]];
_range = param [1,100,[0]];
_return = [];

_houseArray = _center nearObjects ["House",_range];

if !(_houseArray isEqualTo []) then {
	_house = selectRandom _houseArray;
	_housePosArray = _house buildingPos -1;

	if !(_housePosArray isEqualTo []) then {
		{
			if (_x call FUNC(inBuilding)) exitWith {
				_return = [_house,_x];
			};
		} foreach _housePosArray;
	};
};

_return