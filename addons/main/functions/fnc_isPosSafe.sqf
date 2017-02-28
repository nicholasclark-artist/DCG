/*
Author:
Nicholas Clark (SENSEI)

Description:
checks if position is safe

Arguments:
0: position <ARRAY>
1: min distance from object <NUMBER>
2: allow water <NUMBER>
3: max gradient <NUMBER>
4: object to ignore <OBJECT>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"

params [
	["_pos",[0,0,0],[[]]],
	["_dist",5,[0]],
	["_water",-1,[0]],
	["_gradient",-1,[0]],
    ["_ignore",objNull,[objNull]]
];

// always check position at ground level
_pos =+ _pos;
_pos resize 2;

// does not find objects created with createVehicle
private _objs = nearestTerrainObjects [_pos, [], _dist, false];

if !(_objs isEqualTo []) exitWith {false};

_objs = _pos nearObjects ["All",_dist];
_objs = _objs select {
    !(_x isEqualTo _ignore) &&
    {!(_x isKindOf "Logic")} &&
    {getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "scope") > 1}
};

if (!(_objs isEqualTo []) || {_pos isFlatEmpty [-1, -1, _gradient, 30, _water] isEqualTo []}) exitWith {false};

true
