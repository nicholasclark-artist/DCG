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

params ["_data"];

if (_data isEqualTo []) then {
	private ["_mapdata"];

    if (GVAR(month) isEqualTo -1) then {
        GVAR(month) = ceil random 12;
    };

    if (GVAR(time) isEqualTo -1) then {
        GVAR(time) = round random 23;
    };

	GVAR(date) = [missionStart select 0, GVAR(month), ceil random 27, GVAR(time), round random 59];

    {
        if (COMPARE_STR(_x select 0,worldName)) exitWith {
            _mapdata = +(GVAR(mapData) select _forEachIndex);
            _mapdata deleteAt 0;
        };
    } forEach GVAR(mapData);

	if !(_mapdata isEqualTo []) then {
		GVAR(overcast) = ((_mapdata select (_month - 1)) + random 0.05) min 1;
	} else {
		GVAR(overcast) = random [0,0.5,1];
	};
} else {
	GVAR(overcast) = _data select 0;
	GVAR(date) = _data select 1;
};
