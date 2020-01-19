/*
Author:
Nicholas Clark (SENSEI)

Description:
spawn prefab, should not be called directly

Arguments:
0: center position <ARRAY>
0: prefab type <STRING>

Return:
array
__________________________________________________________________*/
#include "script_component.hpp"

params [
    ["_position",DEFAULT_POS,[[]]],
    ["_type","",[""]]
];

private _ret = [];



switch _type do {
    case "mil_cp": {
        // get road position
        private _roads = _position nearRoads 25;
        _roads = _roads select {count (roadsConnectedTo _x) < 3};

        if (_roads isEqualTo []) exitWith {false};

        _position = getPos (_roads select 0);

        // check for empty area
        if ([_position,2.5,0,0.3,_roads select 0] call EFUNC(main,isPosSafe)) then {
            // spawn composition
            private _ret = [_position,_type,-1,true] call EFUNC(main,spawnComposition);

            // spawn units at nodes and append units to return
            {

            } forEach (_ret select 1);

            _ret
        };
    };
    case "": {
        _ret
    };
};

