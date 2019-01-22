/*
Author:
Nicholas Clark (SENSEI)

Description:
find and occupy location

Arguments:
0: data loaded from server profile <ARRAY>

Return:
none
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_data",[],[[]]]
];

if !(_data isEqualTo []) exitWith {
    if !([_data select 1] call EFUNC(main,inSafezones)) then { 
        _data spawn FUNC(setOccupied);
    };
};
// @todo something here is making occupy addon run twice
private _locations = EGVAR(main,locations) select {!([_x select 1] call EFUNC(main,inSafezones))};

if (_locations isEqualTo []) exitWith {
    WARNING("No suitable locations to occupy");
};

(selectRandom _locations) spawn FUNC(setOccupied);
