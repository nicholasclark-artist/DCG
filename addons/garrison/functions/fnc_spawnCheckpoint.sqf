/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn road checkpoint, should not be called directly

Arguments:
0: center positionAGL <ARRAY>

Return:
boolean
__________________________________________________________________*/
#include "script_component.hpp"
#define SCOPE QGVAR(spawnCheckpoint)

params [
    ["_position",[],[[]]]
];

// define scope to break hash loop
scopeName SCOPE;

// get road position
private _roads = _position nearRoads 25;
_roads = _roads select {count (roadsConnectedTo _x) < 3};

if (_roads isEqualTo []) exitWith {false};

_position = getPos (_roads select 0);

// check for empty area
if ([_position,2.5,0,0.3,_roads select 0] call EFUNC(main,isPosSafe)) then {
    // spawn composition
    private _comp = [_position,"mil_cp",-1,true] call EFUNC(main,spawnComposition);

    // spawn units at nodes
    {
        // chance to spawn vehicle
        // if ((_x select 1) > 3 && {PROBABILITY(0.1)}) then {

        // };

        
    } forEach (_comp select 1);
};
