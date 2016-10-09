/*
Author:
Nicholas Clark (SENSEI)

Description:
handle loading data

Arguments:
0: data <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"
#define SUMMER [6,7,8]
#define FALL [9,10,11]
#define WINTER [12,1,2]
#define SPRING [3,4,5]
#define MORNING [5,6,7,8,9,10,11]
#define MIDDAY [12,13,14,15]
#define EVENING [16,17,18,19]
#define NIGHT [20,21,22,23,0,1,2,3,4]

params ["_data"];

if (_data isEqualTo []) then {
	private ["_month","_hour"];

	if (GVAR(season) isEqualTo -1) then {
		GVAR(season) = selectRandom [0,1,2,3];
	};

	call {
		if (GVAR(season) isEqualTo 1) exitWith {_month = selectRandom FALL};
		if (GVAR(season) isEqualTo 2) exitWith {_month = selectRandom WINTER};
		if (GVAR(season) isEqualTo 3) exitWith {_month = selectRandom SPRING};
		_month = selectRandom SUMMER;
	};

	if (GVAR(time) isEqualTo -1) then {
		GVAR(time) = selectRandom [0,1,2,3];
	};
	call {
		if (GVAR(time) isEqualTo 1) exitWith {_hour = selectRandom MIDDAY};
		if (GVAR(time) isEqualTo 2) exitWith {_hour = selectRandom EVENING};
		if (GVAR(time) isEqualTo 3) exitWith {_hour = selectRandom NIGHT};
		_hour = selectRandom MORNING;
	};

	GVAR(date) = [2016, _month, ceil random 27, _hour, round random 59];

	if !(GVAR(mapData) isEqualTo []) then {
		GVAR(overcast) = ((GVAR(mapData) select (_month - 1)) + random 0.05) min 1;
	} else {
		GVAR(overcast) = 0.5 + random 0.2;
	};
} else {
	GVAR(overcast) = _data select 0;
	GVAR(date) = _data select 1;
};