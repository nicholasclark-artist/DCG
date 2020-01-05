/*
Author:
Nicholas Clark (SENSEI)

Description:
find positionASL at roadside 

Arguments:
0: road <OBJECT>

Return:
position
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_road",objNull,[objNull]]
];

private _pos = [];
private _dir = _road getRelDir ((roadsConnectedTo _road) select 0);
_dir = _dir + (180 * round (random 1));

// find new position until position at edge of road
for "_i" from 3 to 10 do {
    if !(isOnRoad [((getPosATL _road) select 0) + (_i * sin (_dir + 90)),((getPosATL _road) select 1) + (_i * cos (_dir + 90))]) exitWith {
        _pos = [((getPosATL _road) select 0) + ((_i - 1) * sin (_dir + 90)),((getPosATL _road) select 1) + ((_i - 1) * cos (_dir + 90))];

        _pos pushBack (ASLZ(_pos));
    };
};

_pos